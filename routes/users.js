import express from "express";
import db from "../db/db.js";
import adminAuth from "../middleware/adminAuth.js";

const router = express.Router();

/**
 * GET /api/users
 * Returns list of registered users
 */
router.get("/", async (req, res) => {
  try {
    const result = await db.query(
      "SELECT id, name, email, phone, role, created_at FROM users ORDER BY id ASC"
    );
    res.json(result.rows);
  } catch (err) {
    console.error("Get users error:", err.message);
    res.status(500).json({ error: "Internal server error" });
  }
});

/**
 * GET /api/users/:id
 */
router.get("/:id", async (req, res) => {
  try {
    const { id } = req.params;
    const result = await db.query(
      "SELECT id, name, email, phone, role, created_at FROM users WHERE id = $1",
      [id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ message: "User not found" });
    }

    res.json(result.rows[0]);
  } catch (err) {
    console.error("Get user error:", err.message);
    res.status(500).json({ error: "Internal server error" });
  }
});

/**
 * PUT /api/users/:id
 */
router.put("/:id", async (req, res) => {
  try {
    const { id } = req.params;
    const { name, email, phone, role } = req.body;

    const result = await db.query(
      `UPDATE users
       SET name = COALESCE($1, name),
           email = COALESCE($2, email),
           phone = COALESCE($3, phone),
           role = COALESCE($4, role)
       WHERE id = $5
       RETURNING id, name, email, phone, role, created_at`,
      [name, email ? email.trim().toLowerCase() : null, phone, role, id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ message: "User not found" });
    }

    res.json(result.rows[0]);
  } catch (err) {
    console.error("Update user error:", err.message);
    res.status(500).json({ error: "Internal server error" });
  }
});

/**
 * DELETE /api/users/:id
 */
router.delete("/:id", adminAuth, async (req, res) => {
  try {
    const { id } = req.params;
    const result = await db.query(
      "DELETE FROM users WHERE id = $1 RETURNING id, name, email",
      [id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ message: "User not found" });
    }

    res.json({ message: "User deleted", user: result.rows[0] });
  } catch (err) {
    console.error("Delete user error:", err.message);
    res.status(500).json({ error: "Internal server error" });
  }
});

/* ========================================================================= */
/* CART SUB-ROUTES (25-26-summer-fullstack store-server implementation)      */
/* ========================================================================= */

/**
 * POST /api/users/cart
 * Body: { email, product_id, quantity? }
 */
router.post("/cart", async (req, res) => {
  try {
    const { email, product_id, quantity = 1 } = req.body;

    if (!email || !product_id) {
      return res.status(400).json({ message: "User email and product_id are required" });
    }

    const trimmedEmail = email.trim().toLowerCase();

    // Check if item already exists in user's cart
    const existing = await db.query(
      "SELECT id, quantity FROM carts WHERE LOWER(user_email) = $1 AND product_id = $2",
      [trimmedEmail, product_id]
    );

    if (existing.rows.length > 0) {
      await db.query(
        "UPDATE carts SET quantity = quantity + $1 WHERE id = $2",
        [quantity, existing.rows[0].id]
      );
    } else {
      await db.query(
        "INSERT INTO carts (user_email, product_id, quantity) VALUES ($1, $2, $3)",
        [trimmedEmail, product_id, quantity]
      );
    }

    // Fetch updated cart joined with products
    const cart = await db.query(
      `SELECT c.id AS cart_id, c.quantity, p.*
       FROM carts c
       JOIN products p ON c.product_id = p.id
       WHERE LOWER(c.user_email) = $1
       ORDER BY c.id ASC`,
      [trimmedEmail]
    );

    res.status(201).json({ cart: cart.rows });
  } catch (err) {
    console.error("Add to cart error:", err.message);
    res.status(500).json({ error: "Internal server error" });
  }
});

/**
 * GET /api/users/cart/:email
 */
router.get("/cart/:email", async (req, res) => {
  try {
    const { email } = req.params;
    const result = await db.query(
      `SELECT c.id AS cart_id, c.quantity, p.*
       FROM carts c
       JOIN products p ON c.product_id = p.id
       WHERE LOWER(c.user_email) = LOWER($1)
       ORDER BY c.id ASC`,
      [email.trim()]
    );

    res.json(result.rows);
  } catch (err) {
    console.error("Get cart error:", err.message);
    res.status(500).json({ error: "Internal server error" });
  }
});

/**
 * DELETE /api/users/cart/:email/:productId
 */
router.delete("/cart/:email/:productId", async (req, res) => {
  try {
    const { email, productId } = req.params;
    const cleanId = String(productId).split("-")[0];
    await db.query(
      "DELETE FROM carts WHERE LOWER(user_email) = LOWER($1) AND (product_id::text = $2 OR id::text = $2 OR product_id::text = $3)",
      [email.trim(), String(productId), cleanId]
    );

    const result = await db.query(
      `SELECT c.id AS cart_id, c.quantity, p.*
       FROM carts c
       JOIN products p ON c.product_id = p.id
       WHERE LOWER(c.user_email) = LOWER($1)`,
      [email.trim()]
    );

    res.json({ message: "Item removed from cart", cart: result.rows });
  } catch (err) {
    console.error("Remove from cart error:", err.message);
    res.status(500).json({ error: "Internal server error" });
  }
});

/**
 * DELETE /api/users/cart/:email
 */
router.delete("/cart/:email", async (req, res) => {
  try {
    const { email } = req.params;
    await db.query(
      "DELETE FROM carts WHERE LOWER(user_email) = LOWER($1)",
      [email.trim()]
    );

    res.json({ message: "Cart cleared", cart: [] });
  } catch (err) {
    console.error("Clear cart error:", err.message);
    res.status(500).json({ error: "Internal server error" });
  }
});

export default router;
