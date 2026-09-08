import express from "express";
import db from "../db/db.js";
import adminAuth from "../middleware/adminAuth.js";

const router = express.Router();

function formatBedroom(row) {
  const images = [];
  if (row.img) images.push(row.img);
  if (row.img2) images.push(row.img2);
  if (row.img3) images.push(row.img3);
  if (images.length === 0) {
    images.push(
      "https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Tayf_4iPZv6iGf.png?updatedAt=1782466205843"
    );
  }

  const priceNum = row.price ? parseFloat(row.price) : 0;
  const price2Num = row.price2 ? parseFloat(row.price2) : null;
  const salePriceNum = row.sale_price ? parseFloat(row.sale_price) : null;
  const salePrice2Num = row.sale_price2 ? parseFloat(row.sale_price2) : null;

  const formattedPrice = row.price
    ? (String(row.price).startsWith("JOD") ? row.price : `JOD ${priceNum.toLocaleString()}`)
    : "Price upon inquiry";

  return {
    id: row.id,
    name: row.name,
    arabicName: row.arabic_nam || "",
    desc: row.desc || "",
    arabicDesc: row.arabic_desc || "",
    category: "Bedrooms",
    arabicCategory: "غرف النوم",
    price: formattedPrice,
    priceNumber: priceNum,
    price2: price2Num,
    price2Formatted: price2Num ? `JOD ${price2Num.toLocaleString()}` : null,
    salePrice: salePriceNum,
    salePriceFormatted: salePriceNum ? `JOD ${salePriceNum.toLocaleString()}` : null,
    salePrice2: salePrice2Num,
    images: images,
    image: images[0],
    stockStatus: row.stock_status || (row.isvisible !== false ? "Active" : "Low Stock"),
    isVisible: row.isvisible !== false,
    sortOrder: row.sort_order || 0,
  };
}

/**
 * GET /api/bedrooms
 */
router.get("/", async (req, res) => {
  try {
    const { all } = req.query;
    const filter = all === "true" ? "" : "WHERE (isvisible IS NULL OR isvisible = true)";
    const result = await db.query(
      `SELECT * FROM bedrooms ${filter} ORDER BY sort_order ASC, id ASC`
    );

    res.json(result.rows.map(formatBedroom));
  } catch (err) {
    console.error("Fetch bedrooms error:", err.message);
    res.status(500).json({ error: "Internal server error" });
  }
});

/**
 * GET /api/bedrooms/:id
 */
router.get("/:id", async (req, res) => {
  try {
    const { id } = req.params;
    const result = await db.query(
      "SELECT * FROM bedrooms WHERE id::text = $1 OR LOWER(name) = LOWER($1)",
      [id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Bedroom piece not found" });
    }

    res.json(formatBedroom(result.rows[0]));
  } catch (err) {
    console.error("Get bedroom error:", err.message);
    res.status(500).json({ error: "Internal server error" });
  }
});

/**
 * POST /api/bedrooms
 * Protected by adminAuth
 */
router.post("/", adminAuth, async (req, res) => {
  try {
    const { name, desc, img, img2, img3, price, price2, sale_price, isvisible = true, sort_order = 0 } = req.body;

    if (!name) {
      return res.status(400).json({ message: "Bedroom piece name is required" });
    }

    const cleanPrice = typeof price === "string" ? parseFloat(price.replace(/[^0-9.]/g, "")) || 0 : price;

    const result = await db.query(
      `INSERT INTO bedrooms (name, "desc", img, img2, img3, price, price2, sale_price, isvisible, sort_order)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)
       RETURNING *`,
      [name.trim(), desc || null, img || null, img2 || null, img3 || null, cleanPrice, price2 || null, sale_price || null, isvisible, sort_order]
    );

    res.status(201).json(formatBedroom(result.rows[0]));
  } catch (err) {
    console.error("Create bedroom error:", err.message);
    res.status(500).json({ error: "Internal server error" });
  }
});

/**
 * PUT /api/bedrooms/sort
 * Protected by adminAuth - Batch update sort order for bedrooms
 */
router.put("/sort", adminAuth, async (req, res) => {
  try {
    const { items } = req.body;
    if (!Array.isArray(items)) {
      return res.status(400).json({ message: "Items array is required" });
    }

    for (const item of items) {
      if (item.id !== undefined && item.sortOrder !== undefined) {
        await db.query("UPDATE bedrooms SET sort_order = $1 WHERE id = $2", [
          parseInt(item.sortOrder, 10),
          parseInt(item.id, 10),
        ]);
      }
    }

    res.json({ message: "Bedroom sort orders updated successfully" });
  } catch (err) {
    console.error("Bedroom sort order update error:", err.message);
    res.status(500).json({ error: "Internal server error" });
  }
});

/**
 * PUT /api/bedrooms/:id
 * Protected by adminAuth
 */
router.put("/:id", adminAuth, async (req, res) => {
  try {
    const { id } = req.params;
    const { name, desc, img, img2, img3, price, price2, isvisible, isVisible, sort_order } = req.body;

    const cleanPrice =
      price !== undefined
        ? typeof price === "string"
          ? parseFloat(price.replace(/[^0-9.]/g, "")) || null
          : price
        : null;

    const cleanPrice2 =
      price2 !== undefined
        ? typeof price2 === "string"
          ? parseFloat(price2.replace(/[^0-9.]/g, "")) || null
          : price2
        : null;

    const finalIsVisible = isvisible !== undefined ? isvisible : (isVisible !== undefined ? isVisible : null);

    const result = await db.query(
      `UPDATE bedrooms
       SET name = COALESCE($1, name),
           "desc" = COALESCE($2, "desc"),
           img = COALESCE($3, img),
           img2 = COALESCE($4, img2),
           img3 = COALESCE($5, img3),
           price = COALESCE($6, price),
           price2 = COALESCE($7, price2),
           isvisible = COALESCE($8, isvisible),
           sort_order = COALESCE($9, sort_order)
       WHERE id = $10
       RETURNING *`,
      [name, desc, img, img2, img3, cleanPrice, cleanPrice2, finalIsVisible, sort_order, id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Bedroom piece not found" });
    }

    res.json(formatBedroom(result.rows[0]));
  } catch (err) {
    console.error("Update bedroom error:", err.message);
    res.status(500).json({ error: "Internal server error" });
  }
});

/**
 * DELETE /api/bedrooms/:id
 * Protected by adminAuth
 */
router.delete("/:id", adminAuth, async (req, res) => {
  try {
    const { id } = req.params;
    const result = await db.query("DELETE FROM bedrooms WHERE id = $1 RETURNING *", [id]);

    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Bedroom piece not found" });
    }

    res.json({ message: "Bedroom piece deleted", deleted: result.rows[0] });
  } catch (err) {
    console.error("Delete bedroom error:", err.message);
    res.status(500).json({ error: "Internal server error" });
  }
});

export default router;
