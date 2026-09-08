import express from "express";
import db from "../db/db.js";
import adminAuth from "../middleware/adminAuth.js";

const router = express.Router();

function formatClient(row) {
  const spentNum = row.total_spent ? parseFloat(row.total_spent) : 0;
  const formattedSpent = String(row.total_spent || "").startsWith("JOD")
    ? row.total_spent
    : `JOD ${spentNum.toLocaleString()}`;

  return {
    id: row.id,
    name: row.name,
    email: row.email,
    phone: row.phone || "+962 7 9000 0000",
    city: row.city || "Amman",
    orders: row.total_orders || 0,
    spent: formattedSpent,
    spentNumber: spentNum,
    status: row.status || "Active",
    lastActive: row.last_active || "Recently",
    createdAt: row.created_at,
  };
}

/**
 * GET /api/clients
 * Optional query params: ?status=..., ?search=...
 */
router.get("/", async (req, res) => {
  try {
    const { status, search } = req.query;

    let query = "SELECT * FROM clients WHERE 1=1";
    const params = [];

    if (status && status !== "All") {
      params.push(status);
      query += ` AND LOWER(status) = LOWER($${params.length})`;
    }

    if (search && search.trim()) {
      params.push(`%${search.trim()}%`);
      query += ` AND (LOWER(name) LIKE LOWER($${params.length}) OR LOWER(email) LIKE LOWER($${params.length}) OR LOWER(city) LIKE LOWER($${params.length}) OR LOWER(phone) LIKE LOWER($${params.length}))`;
    }

    query += " ORDER BY total_spent DESC, id ASC";

    const result = await db.query(query, params);
    res.json(result.rows.map(formatClient));
  } catch (err) {
    console.error("Fetch clients error:", err.message);
    res.status(500).json({ error: "Internal server error" });
  }
});

/**
 * GET /api/clients/:id
 */
router.get("/:id", async (req, res) => {
  try {
    const { id } = req.params;
    const result = await db.query(
      "SELECT * FROM clients WHERE id::text = $1 OR LOWER(email) = LOWER($1)",
      [id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Client not found" });
    }

    res.json(formatClient(result.rows[0]));
  } catch (err) {
    console.error("Get client error:", err.message);
    res.status(500).json({ error: "Internal server error" });
  }
});

/**
 * POST /api/clients
 * Protected by adminAuth
 */
router.post("/", adminAuth, async (req, res) => {
  try {
    const { name, email, phone, city, status = "Active", total_orders = 0, total_spent = 0 } = req.body;

    if (!name || !email) {
      return res.status(400).json({ message: "Client name and email are required" });
    }

    const cleanSpent = typeof total_spent === "string" ? parseFloat(total_spent.replace(/[^0-9.]/g, "")) || 0 : total_spent;

    const result = await db.query(
      `INSERT INTO clients (name, email, phone, city, status, total_orders, total_spent, last_active)
       VALUES ($1, $2, $3, $4, $5, $6, $7, 'Just now')
       RETURNING *`,
      [name.trim(), email.trim().toLowerCase(), phone || null, city || "Amman", status, total_orders, cleanSpent]
    );

    res.status(201).json(formatClient(result.rows[0]));
  } catch (err) {
    console.error("Create client error:", err.message);
    res.status(500).json({ error: "Internal server error" });
  }
});

/**
 * PUT /api/clients/:id
 * Protected by adminAuth
 */
router.put("/:id", adminAuth, async (req, res) => {
  try {
    const { id } = req.params;
    const { name, email, phone, city, status, total_orders, total_spent, last_active } = req.body;

    const cleanSpent =
      total_spent !== undefined
        ? typeof total_spent === "string"
          ? parseFloat(total_spent.replace(/[^0-9.]/g, "")) || 0
          : total_spent
        : null;

    const result = await db.query(
      `UPDATE clients
       SET name = COALESCE($1, name),
           email = COALESCE($2, email),
           phone = COALESCE($3, phone),
           city = COALESCE($4, city),
           status = COALESCE($5, status),
           total_orders = COALESCE($6, total_orders),
           total_spent = COALESCE($7, total_spent),
           last_active = COALESCE($8, last_active)
       WHERE id = $9
       RETURNING *`,
      [name, email ? email.trim().toLowerCase() : null, phone, city, status, total_orders, cleanSpent, last_active, id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Client not found" });
    }

    res.json(formatClient(result.rows[0]));
  } catch (err) {
    console.error("Update client error:", err.message);
    res.status(500).json({ error: "Internal server error" });
  }
});

/**
 * DELETE /api/clients/:id
 * Protected by adminAuth
 */
router.delete("/:id", adminAuth, async (req, res) => {
  try {
    const { id } = req.params;
    const result = await db.query("DELETE FROM clients WHERE id = $1 RETURNING *", [id]);

    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Client not found" });
    }

    res.json({ message: "Client deleted", deleted: result.rows[0] });
  } catch (err) {
    console.error("Delete client error:", err.message);
    res.status(500).json({ error: "Internal server error" });
  }
});

export default router;
