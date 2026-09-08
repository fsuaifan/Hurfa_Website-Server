import express from "express";
import db from "../db/db.js";
import adminAuth from "../middleware/adminAuth.js";

const router = express.Router();

/**
 * GET /api/categories
 */
router.get("/", async (req, res) => {
  try {
    const result = await db.query(
      "SELECT * FROM categories ORDER BY id ASC"
    );
    res.json(result.rows);
  } catch (err) {
    console.error("Fetch categories error:", err.message);
    res.status(500).json({ error: "Internal server error" });
  }
});

/**
 * GET /api/categories/:id
 */
router.get("/:id", async (req, res) => {
  try {
    const { id } = req.params;
    const result = await db.query(
      "SELECT * FROM categories WHERE id::text = $1 OR LOWER(name) = LOWER($1)",
      [id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Category not found" });
    }

    res.json(result.rows[0]);
  } catch (err) {
    console.error("Get category error:", err.message);
    res.status(500).json({ error: "Internal server error" });
  }
});

/**
 * POST /api/categories
 * Protected by adminAuth
 */
router.post("/", adminAuth, async (req, res) => {
  try {
    const { name, arabic_name } = req.body;

    if (!name) {
      return res.status(400).json({ message: "Category name is required" });
    }

    const result = await db.query(
      "INSERT INTO categories (name, arabic_name) VALUES ($1, $2) RETURNING *",
      [name.trim(), arabic_name ? arabic_name.trim() : null]
    );

    res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error("Create category error:", err.message);
    res.status(500).json({ error: "Internal server error" });
  }
});

/**
 * PUT /api/categories/:id
 * Protected by adminAuth
 */
router.put("/:id", adminAuth, async (req, res) => {
  try {
    const { id } = req.params;
    const { name, arabic_name } = req.body;

    const result = await db.query(
      `UPDATE categories
       SET name = COALESCE($1, name),
           arabic_name = COALESCE($2, arabic_name)
       WHERE id = $3
       RETURNING *`,
      [name, arabic_name, id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Category not found" });
    }

    res.json(result.rows[0]);
  } catch (err) {
    console.error("Update category error:", err.message);
    res.status(500).json({ error: "Internal server error" });
  }
});

/**
 * DELETE /api/categories/:id
 * Protected by adminAuth
 */
router.delete("/:id", adminAuth, async (req, res) => {
  try {
    const { id } = req.params;
    const result = await db.query(
      "DELETE FROM categories WHERE id = $1 RETURNING *",
      [id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Category not found" });
    }

    res.json({ message: "Category deleted", deleted: result.rows[0] });
  } catch (err) {
    console.error("Delete category error:", err.message);
    res.status(500).json({ error: "Internal server error" });
  }
});

export default router;
