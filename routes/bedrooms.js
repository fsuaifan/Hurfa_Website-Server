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

  const formattedPrice = row.price
    ? (String(row.price).startsWith("JOD") ? row.price : `JOD ${Number(row.price).toLocaleString()}`)
    : "Price upon inquiry";

  return {
    id: row.id,
    name: row.name,
    desc: row.desc || row.arabic_desc || "",
    category: "Bedrooms",
    price: formattedPrice,
    priceNumber: row.price ? parseFloat(row.price) : 0,
    price2: row.price2 ? parseFloat(row.price2) : null,
    salePrice: row.sale_price ? parseFloat(row.sale_price) : null,
    images: images,
    image: images[0],
    isVisible: row.isvisible !== false,
  };
}

/**
 * GET /api/bedrooms
 */
router.get("/", async (req, res) => {
  try {
    const result = await db.query(
      "SELECT * FROM bedrooms WHERE (isvisible IS NULL OR isvisible = true) ORDER BY sort_order ASC, id ASC"
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
 * PUT /api/bedrooms/:id
 * Protected by adminAuth
 */
router.put("/:id", adminAuth, async (req, res) => {
  try {
    const { id } = req.params;
    const { name, desc, img, img2, img3, price, isvisible, sort_order } = req.body;

    const cleanPrice =
      price !== undefined
        ? typeof price === "string"
          ? parseFloat(price.replace(/[^0-9.]/g, "")) || null
          : price
        : null;

    const result = await db.query(
      `UPDATE bedrooms
       SET name = COALESCE($1, name),
           "desc" = COALESCE($2, "desc"),
           img = COALESCE($3, img),
           img2 = COALESCE($4, img2),
           img3 = COALESCE($5, img3),
           price = COALESCE($6, price),
           isvisible = COALESCE($7, isvisible),
           sort_order = COALESCE($8, sort_order)
       WHERE id = $9
       RETURNING *`,
      [name, desc, img, img2, img3, cleanPrice, isvisible, sort_order, id]
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
