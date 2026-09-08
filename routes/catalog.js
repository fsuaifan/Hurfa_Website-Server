import express from "express";
import db from "../db/db.js";
import adminAuth from "../middleware/adminAuth.js";

const router = express.Router();

function formatCatalogItem(row) {
  const priceNum = row.price ? parseFloat(row.price) : 0;
  const formattedPrice = row.price
    ? (String(row.price).startsWith("JOD") ? row.price : `JOD ${priceNum.toLocaleString()}`)
    : "Price upon inquiry";

  const images = [];
  if (row.img) images.push(row.img);
  if (row.img2) images.push(row.img2);
  if (row.img3) images.push(row.img3);
  if (images.length === 0) {
    images.push(
      "https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Wesal-Collection_n299cVlM5.jpg?updatedAt=1787138960280"
    );
  }

  return {
    id: row.id,
    name: row.name,
    desc: row.desc1 || row.desc || row.arabic_desc || "",
    category: row.category_name || row.category || "General",
    categoryId: row.category_id,
    price: formattedPrice,
    priceNumber: priceNum,
    salePrice: row.sale_price ? parseFloat(row.sale_price) : null,
    images: images,
    image: images[0],
    material: row.material || "Crafted Solid Wood & Fine Hardware",
    dimensions: row.dimensions || "Custom Architectural Sizing",
    stockStatus: row.stock_status || (row.isvisible !== false ? "Active" : "Low Stock"),
    isVisible: row.isvisible !== false,
    sortOrder: row.sort_order || 0,
  };
}

/**
 * GET /api/catalog/stats
 * Returns live aggregated statistics for the Studio Admin Dashboard
 */
router.get("/stats", async (req, res) => {
  try {
    const productsCountRes = await db.query(
      "SELECT COUNT(*) AS total_items FROM products WHERE isvisible IS NULL OR isvisible = true"
    );
    const totalItems = parseInt(productsCountRes.rows[0].total_items, 10) || 0;

    const ordersStatsRes = await db.query(
      `SELECT 
         COUNT(*) AS total_orders,
         COALESCE(SUM(total_price), 0) AS gross_revenue,
         COUNT(*) FILTER (WHERE LOWER(status) IN ('in production', 'consultation scheduled', 'ready for delivery', 'pending')) AS active_orders
       FROM orders`
    );
    const grossRevenueNum = parseFloat(ordersStatsRes.rows[0].gross_revenue) || 0;
    const activeOrders = parseInt(ordersStatsRes.rows[0].active_orders, 10) || 0;

    const clientsCountRes = await db.query(
      "SELECT COUNT(*) AS total_clients FROM clients"
    );
    const totalClients = parseInt(clientsCountRes.rows[0].total_clients, 10) || 0;

    res.json({
      totalCatalogItems: totalItems,
      totalCatalogItemsFormatted: `${totalItems} Pieces`,
      grossRevenue: `JOD ${grossRevenueNum.toLocaleString()}`,
      grossRevenueNumber: grossRevenueNum,
      activeOrders: activeOrders,
      activeOrdersFormatted: `${activeOrders} In Progress`,
      totalClients: totalClients,
      totalClientsFormatted: `${totalClients} Patrons`,
      lastUpdated: new Date().toISOString(),
    });
  } catch (err) {
    console.error("Fetch catalog stats error:", err.message);
    res.status(500).json({ error: "Internal server error" });
  }
});

/**
 * GET /api/catalog
 */
router.get("/", async (req, res) => {
  try {
    const { category, search, sort } = req.query;

    let query = `
      SELECT p.*, c.name AS category_name, c.arabic_name AS category_arabic_name
      FROM products p
      LEFT JOIN categories c ON p.category_id = c.id
      WHERE 1=1
    `;
    const params = [];

    if (category && category !== "All") {
      params.push(`%${category}%`);
      query += ` AND (LOWER(c.name) LIKE LOWER($${params.length}) OR LOWER(p.name) LIKE LOWER($${params.length}))`;
    }

    if (search && search.trim()) {
      params.push(`%${search.trim()}%`);
      query += ` AND (LOWER(p.name) LIKE LOWER($${params.length}) OR LOWER(p.desc1) LIKE LOWER($${params.length}) OR LOWER(c.name) LIKE LOWER($${params.length}))`;
    }

    if (sort === "price-low") {
      query += " ORDER BY p.price ASC NULLS LAST, p.id ASC";
    } else if (sort === "price-high") {
      query += " ORDER BY p.price DESC NULLS LAST, p.id ASC";
    } else {
      query += " ORDER BY p.id ASC";
    }

    const result = await db.query(query, params);
    res.json(result.rows.map(formatCatalogItem));
  } catch (err) {
    console.error("Fetch catalog error:", err.message);
    res.status(500).json({ error: "Internal server error" });
  }
});

/**
 * GET /api/catalog/:id
 */
router.get("/:id", async (req, res) => {
  try {
    const { id } = req.params;
    const result = await db.query(
      `SELECT p.*, c.name AS category_name, c.arabic_name AS category_arabic_name
       FROM products p
       LEFT JOIN categories c ON p.category_id = c.id
       WHERE p.id = $1`,
      [id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Catalog item not found" });
    }

    res.json(formatCatalogItem(result.rows[0]));
  } catch (err) {
    console.error("Get catalog item error:", err.message);
    res.status(500).json({ error: "Internal server error" });
  }
});

/**
 * POST /api/catalog
 * Protected by adminAuth
 */
router.post("/", adminAuth, async (req, res) => {
  try {
    const { name, price, desc, category, category_id, img, material, dimensions, stockStatus } = req.body;

    if (!name || price === undefined || price === null) {
      return res.status(400).json({ message: "Item name and price are required" });
    }

    const cleanPrice = typeof price === "string" ? parseFloat(price.replace(/[^0-9.]/g, "")) || 0 : price;
    const finalImg = img || "https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Wesal-Collection_n299cVlM5.jpg?updatedAt=1787138960280";

    let finalCategoryId = category_id || null;
    if (!finalCategoryId && category) {
      const catLookup = await db.query("SELECT id FROM categories WHERE LOWER(name) = LOWER($1)", [category]);
      if (catLookup.rows.length > 0) {
        finalCategoryId = catLookup.rows[0].id;
      }
    }

    const result = await db.query(
      `INSERT INTO products (name, price, desc1, category_id, img, material, dimensions, stock_status)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
       RETURNING *`,
      [name.trim(), cleanPrice, desc || null, finalCategoryId, finalImg, material || null, dimensions || null, stockStatus || "Active"]
    );

    res.status(201).json(formatCatalogItem(result.rows[0]));
  } catch (err) {
    console.error("Create catalog item error:", err.message);
    res.status(500).json({ error: "Internal server error" });
  }
});

/**
 * PUT /api/catalog/sort
 * Protected by adminAuth - Batch update sort order
 */
router.put("/sort", adminAuth, async (req, res) => {
  try {
    const { items } = req.body;
    if (!Array.isArray(items)) {
      return res.status(400).json({ message: "Items array is required" });
    }

    for (const item of items) {
      if (item.id !== undefined && item.sortOrder !== undefined) {
        await db.query("UPDATE products SET sort_order = $1 WHERE id = $2", [
          parseInt(item.sortOrder, 10),
          parseInt(item.id, 10),
        ]);
      }
    }

    res.json({ message: "Sort orders updated successfully" });
  } catch (err) {
    console.error("Sort order update error:", err.message);
    res.status(500).json({ error: "Internal server error" });
  }
});

/**
 * PUT /api/catalog/:id
 * Protected by adminAuth
 */
router.put("/:id", adminAuth, async (req, res) => {
  try {
    const { id } = req.params;
    const { name, price, desc, category, category_id, img, material, dimensions, stockStatus, isVisible } = req.body;

    const existing = await db.query("SELECT * FROM products WHERE id = $1", [id]);
    if (existing.rows.length === 0) {
      return res.status(404).json({ message: "Catalog item not found" });
    }

    const current = existing.rows[0];
    const cleanPrice =
      price !== undefined
        ? typeof price === "string"
          ? parseFloat(price.replace(/[^0-9.]/g, "")) || current.price
          : price
        : current.price;

    let finalCategoryId = category_id !== undefined ? category_id : current.category_id;
    if (category && category !== "All") {
      const catLookup = await db.query("SELECT id FROM categories WHERE LOWER(name) = LOWER($1)", [category]);
      if (catLookup.rows.length > 0) {
        finalCategoryId = catLookup.rows[0].id;
      }
    }

    const result = await db.query(
      `UPDATE products
       SET name = COALESCE($1, name),
           price = COALESCE($2, price),
           desc1 = COALESCE($3, desc1),
           category_id = COALESCE($4, category_id),
           img = COALESCE($5, img),
           material = COALESCE($6, material),
           dimensions = COALESCE($7, dimensions),
           stock_status = COALESCE($8, stock_status),
           isvisible = COALESCE($9, isvisible)
       WHERE id = $10
       RETURNING *`,
      [name, cleanPrice, desc, finalCategoryId, img, material, dimensions, stockStatus, isVisible, id]
    );

    res.json(formatCatalogItem(result.rows[0]));
  } catch (err) {
    console.error("Update catalog item error:", err.message);
    res.status(500).json({ error: "Internal server error" });
  }
});

/**
 * DELETE /api/catalog/:id
 * Protected by adminAuth
 */
router.delete("/:id", adminAuth, async (req, res) => {
  try {
    const { id } = req.params;
    const result = await db.query("DELETE FROM products WHERE id = $1 RETURNING *", [id]);

    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Catalog item not found" });
    }

    res.json({ message: "Catalog item deleted", deleted: result.rows[0] });
  } catch (err) {
    console.error("Delete catalog item error:", err.message);
    res.status(500).json({ error: "Internal server error" });
  }
});

export default router;
