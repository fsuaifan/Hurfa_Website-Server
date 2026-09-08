import express from "express";
import db from "../db/db.js";
import adminAuth from "../middleware/adminAuth.js";

const router = express.Router();

/**
 * Helper function to format product records for consistent client response
 */
function normalizeStockStatus(status) {
  if (!status) return "In Stock";
  const s = String(status).toLowerCase().replace(/[-_]/g, " ").trim();
  if (s === "low stock" || s === "low") return "Low Stock";
  if (s === "out of stock" || s === "out") return "Out of Stock";
  return "In Stock";
}

function formatProduct(row) {
  const priceNum = row.price ? parseFloat(row.price) : 0;
  const formattedPrice = row.price
    ? (String(row.price).startsWith("JOD") ? row.price : `JOD ${Number(row.price).toLocaleString()}`)
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
    arabicName: row.arabic_nam || "",
    desc: row.desc1 || row.desc || "",
    arabicDesc: row.arabic_desc || "",
    category: row.category_name || row.category || "General",
    arabicCategory: row.category_arabic_name || "",
    categoryId: row.category_id,
    price: formattedPrice,
    priceNumber: priceNum,
    salePrice: row.sale_price ? parseFloat(row.sale_price) : null,
    images: images,
    image: images[0],
    material: row.material || "Crafted Solid Wood & Fine Hardware",
    dimensions: row.dimensions || "Custom Architectural Sizing",
    stockStatus: normalizeStockStatus(row.stock_status),
    isVisible: row.isvisible !== false,
    sortOrder: row.sort_order || 0,
  };
}

function formatPremiumCollection(row) {
  const priceNum = row.price ? parseFloat(row.price) : 0;
  const salePriceNum = row.sale_price ? parseFloat(row.sale_price) : null;
  const images = [];
  if (row.main_img) images.push(row.main_img);
  if (row.img1) images.push(row.img1);
  if (row.img2) images.push(row.img2);
  if (row.img3) images.push(row.img3);
  if (row.img4) images.push(row.img4);
  if (images.length === 0) {
    images.push(
      "https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Wesal-Collection_n299cVlM5.jpg?updatedAt=1787138960280"
    );
  }

  const isOud = (row.name || '').toLowerCase().includes('oud');
  const isWesal = (row.name || '').toLowerCase().includes('wesal');

  return {
    id: row.id,
    title: row.name,
    name: row.name,
    arabicName: isOud ? 'مجموعة العود' : isWesal ? 'مجموعة وصال' : row.name,
    tagline: isOud ? 'Solid Oak & Bouclé' : isWesal ? 'Walnut & Architectural Linen' : 'Architectural Suite',
    arabicTagline: isOud ? 'خشب بلوط صلب وقماش بوكليه' : isWesal ? 'خشب جوز وكتان معماري' : 'مجموعة معمارية',
    desc: row.desc || (isOud ? 'A signature living-room collection built around solid oak framing, subtle warm curves, and boucle upholstery.' : isWesal ? 'A bedroom collection defined by low-profile walnut woodwork, soft textiles, and serene minimalist balance.' : 'Signature whole-room collection engineered with unified tone and fine materials.'),
    arabicDesc: isOud ? 'مجموعة غرفة جلوس مميزة مبنية حول هيكل من خشب البلوط الصلب ومنحنيات دافئة وتنجيد بوكليه فاخر.' : isWesal ? 'مجموعة غرفة نوم تتميز بالخشب المنخفض من خشب الجوز والأقمشة الناعمة والتوازن الهادئ.' : 'مجموعة معمارية متكاملة مصممة بنبرة ومواد موحدة.',
    description: row.desc || (isOud ? 'A signature living-room collection built around solid oak framing, subtle warm curves, and boucle upholstery.' : isWesal ? 'A bedroom collection defined by low-profile walnut woodwork, soft textiles, and serene minimalist balance.' : 'Signature whole-room collection engineered with unified tone and fine materials.'),
    price: `JOD ${priceNum.toLocaleString()}`,
    priceNumber: priceNum,
    priceRange: salePriceNum ? `JOD ${salePriceNum.toLocaleString()}` : `JOD ${priceNum.toLocaleString()}`,
    salePrice: salePriceNum,
    salePriceFormatted: salePriceNum ? `JOD ${salePriceNum.toLocaleString()}` : null,
    image: row.main_img || images[0],
    mainImage: row.main_img || images[0],
    images: images,
  };
}

/**
 * GET /api/products
 * Optional Query Params: ?category=..., ?search=..., ?sort=price-low|price-high|newest
 */
router.get("/", async (req, res) => {
  try {
    const { category, search, sort, all } = req.query;

    let query = `
      SELECT p.*, c.name AS category_name, c.arabic_name AS category_arabic_name
      FROM products p
      LEFT JOIN categories c ON p.category_id = c.id
      WHERE 1=1
    `;
    const params = [];

    if (all !== "true") {
      query += ` AND (p.isvisible IS NULL OR p.isvisible = true)`;
    }

    if (category && category !== "All") {
      params.push(`%${category}%`);
      query += ` AND (LOWER(c.name) LIKE LOWER($${params.length}) OR LOWER(p.name) LIKE LOWER($${params.length}))`;
    }

    if (search && search.trim()) {
      params.push(`%${search.trim()}%`);
      query += ` AND (LOWER(p.name) LIKE LOWER($${params.length}) OR LOWER(p.desc1) LIKE LOWER($${params.length}) OR LOWER(c.name) LIKE LOWER($${params.length}))`;
    }

    if (sort === "price-low" || sort === "price_asc") {
      query += " ORDER BY COALESCE(p.sale_price, p.price) ASC NULLS LAST, p.id ASC";
    } else if (sort === "price-high" || sort === "price_desc") {
      query += " ORDER BY COALESCE(p.sale_price, p.price) DESC NULLS LAST, p.id ASC";
    } else if (sort === "newest") {
      query += " ORDER BY p.id DESC";
    } else {
      query += " ORDER BY p.sort_order ASC, p.id ASC";
    }

    const result = await db.query(query, params);
    res.json(result.rows.map(formatProduct));
  } catch (err) {
    console.error("Fetch products error:", err.message);
    res.status(500).json({ error: "Internal server error" });
  }
});

/**
 * GET /api/products/premium
 */
router.get("/premium", async (req, res) => {
  try {
    const result = await db.query(
      "SELECT * FROM premium_collection ORDER BY id ASC"
    );
    res.json(result.rows.map(formatPremiumCollection));
  } catch (err) {
    console.error("Fetch premium collections error:", err.message);
    res.status(500).json({ error: "Internal server error" });
  }
});

/**
 * GET /api/products/premium/:id
 */
router.get("/premium/:id", async (req, res) => {
  try {
    const { id } = req.params;
    const result = await db.query(
      "SELECT * FROM premium_collection WHERE id::text = $1 OR LOWER(name) = LOWER($1)",
      [id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Premium collection not found" });
    }

    res.json(formatPremiumCollection(result.rows[0]));
  } catch (err) {
    console.error("Get premium collection error:", err.message);
    res.status(500).json({ error: "Internal server error" });
  }
});

/**
 * GET /api/products/:id
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
      return res.status(404).json({ message: "Product not found" });
    }

    res.json(formatProduct(result.rows[0]));
  } catch (err) {
    console.error("Get product error:", err.message);
    res.status(500).json({ error: "Internal server error" });
  }
});

/**
 * POST /api/products
 * Protected by adminAuth
 */
router.post("/", adminAuth, async (req, res) => {
  try {
    const { name, price, desc, category, category_id, img, material, dimensions, stockStatus } = req.body;

    if (!name || price === undefined || price === null) {
      return res.status(400).json({ message: "Product name and price are required" });
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

    res.status(201).json(formatProduct(result.rows[0]));
  } catch (err) {
    console.error("Create product error:", err.message);
    res.status(500).json({ error: "Internal server error" });
  }
});

/**
 * PUT /api/products/sort
 * Protected by adminAuth - Batch update sort order for products
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

    res.json({ message: "Product sort orders updated successfully" });
  } catch (err) {
    console.error("Product sort order update error:", err.message);
    res.status(500).json({ error: "Internal server error" });
  }
});

/**
 * PUT /api/products/:id
 * Protected by adminAuth
 */
router.put("/:id", adminAuth, async (req, res) => {
  try {
    const { id } = req.params;
    const { name, price, desc, category, category_id, img, material, dimensions, stockStatus, isVisible, isvisible } = req.body;

    const existing = await db.query("SELECT * FROM products WHERE id = $1", [id]);
    if (existing.rows.length === 0) {
      return res.status(404).json({ message: "Product not found" });
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

    const finalIsVisible = isVisible !== undefined ? isVisible : (isvisible !== undefined ? isvisible : null);
    const finalStockStatus = stockStatus !== undefined ? stockStatus : null;

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
      [name, cleanPrice, desc, finalCategoryId, img, material, dimensions, finalStockStatus, finalIsVisible, id]
    );

    res.json(formatProduct(result.rows[0]));
  } catch (err) {
    console.error("Update product error:", err.message);
    res.status(500).json({ error: "Internal server error" });
  }
});

/**
 * DELETE /api/products/:id
 * Protected by adminAuth
 */
router.delete("/:id", adminAuth, async (req, res) => {
  try {
    const { id } = req.params;
    const result = await db.query("DELETE FROM products WHERE id = $1 RETURNING *", [id]);

    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Product not found" });
    }

    res.json({ message: "Product deleted", deleted: result.rows[0] });
  } catch (err) {
    console.error("Delete product error:", err.message);
    res.status(500).json({ error: "Internal server error" });
  }
});

export default router;
