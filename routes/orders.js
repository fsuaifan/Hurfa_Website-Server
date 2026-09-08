import express from "express";
import db from "../db/db.js";
import adminAuth from "../middleware/adminAuth.js";

const router = express.Router();

function formatOrder(row) {
  const totalNum = row.total_price ? parseFloat(row.total_price) : 0;
  const formattedTotal = String(row.total_price || "").startsWith("JOD")
    ? row.total_price
    : `JOD ${totalNum.toLocaleString()}`;

  const dateFormatted = row.order_date
    ? new Date(row.order_date).toLocaleDateString("en-US", {
        month: "short",
        day: "numeric",
        year: "numeric",
      })
    : "Recent";

  return {
    id: row.order_code || `ORD-2026-${row.orderid}`,
    orderId: row.orderid,
    clientName: row.name || row.client_name || "Valued Patron",
    clientEmail: row.email || row.client_email || "",
    clientPhone: row.phone || row.client_phone || "",
    deliveryAddress: row.delivery_address || "Amman, Jordan",
    items: row.items_list || "Bespoke Architectural Furniture",
    total: formattedTotal,
    totalNumber: totalNum,
    date: dateFormatted,
    status: row.status || "In Production",
  };
}

/**
 * GET /api/orders
 * Optional Query params: ?status=..., ?search=...
 */
router.get("/", async (req, res) => {
  try {
    const { status, search } = req.query;

    let query = "SELECT * FROM orders WHERE 1=1";
    const params = [];

    if (status && status !== "All") {
      params.push(status);
      query += ` AND LOWER(status) = LOWER($${params.length})`;
    }

    if (search && search.trim()) {
      params.push(`%${search.trim()}%`);
      query += ` AND (LOWER(name) LIKE LOWER($${params.length}) OR LOWER(email) LIKE LOWER($${params.length}) OR LOWER(items_list) LIKE LOWER($${params.length}) OR LOWER(order_code) LIKE LOWER($${params.length}))`;
    }

    query += " ORDER BY orderid DESC";

    const result = await db.query(query, params);
    res.json(result.rows.map(formatOrder));
  } catch (err) {
    console.error("Fetch orders error:", err.message);
    res.status(500).json({ error: "Internal server error" });
  }
});

/**
 * GET /api/orders/:id
 */
router.get("/:id", async (req, res) => {
  try {
    const { id } = req.params;
    const result = await db.query(
      "SELECT * FROM orders WHERE orderid::text = $1 OR LOWER(order_code) = LOWER($1)",
      [id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Order not found" });
    }

    res.json(formatOrder(result.rows[0]));
  } catch (err) {
    console.error("Get order error:", err.message);
    res.status(500).json({ error: "Internal server error" });
  }
});

/**
 * POST /api/orders
 * Body: { clientName, clientEmail, clientPhone, items, deliveryAddress, total, status? }
 */
router.post("/", async (req, res) => {
  try {
    const {
      clientName,
      name,
      clientEmail,
      email,
      clientPhone,
      phone,
      items,
      items_list,
      deliveryAddress,
      delivery_address,
      total,
      total_price,
      status = "In Production",
    } = req.body;

    const finalName = clientName || name;
    const finalEmail = (clientEmail || email || "").trim();
    const finalPhone = clientPhone || phone || "+962 7 9000 0000";
    const finalItems = items || items_list || "Hurfa Architectural Selection";
    const finalAddress = deliveryAddress || delivery_address || "Amman, Jordan";

    const rawTotal = total || total_price || 0;
    const cleanTotal = typeof rawTotal === "string" ? parseFloat(rawTotal.replace(/[^0-9.]/g, "")) || 0 : rawTotal;

    const orderCode = `ORD-${new Date().getFullYear()}-${Math.floor(100 + Math.random() * 900)}`;

    const result = await db.query(
      `INSERT INTO orders (name, email, phone, items_list, total_price, order_code, delivery_address, status)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
       RETURNING *`,
      [finalName, finalEmail, finalPhone, finalItems, cleanTotal, orderCode, finalAddress, status]
    );

    // Sync client stats if email provided
    if (finalEmail) {
      try {
        await db.query(
          `INSERT INTO clients (name, email, phone, city, total_orders, total_spent, status, last_active)
           VALUES ($1, $2, $3, $4, 1, $5, 'Active', 'Just now')
           ON CONFLICT (email)
           DO UPDATE SET
             total_orders = clients.total_orders + 1,
             total_spent = clients.total_spent + EXCLUDED.total_spent,
             last_active = 'Just now'`,
          [finalName || "Patron", finalEmail, finalPhone, finalAddress.split(",")[0] || "Amman", cleanTotal]
        );
      } catch (clientErr) {
        console.warn("Could not sync client record:", clientErr.message);
      }
    }

    res.status(201).json(formatOrder(result.rows[0]));
  } catch (err) {
    console.error("Place order error:", err.message);
    res.status(500).json({ error: "Internal server error" });
  }
});

/**
 * PUT /api/orders/:id/status
 */
router.put("/:id/status", async (req, res) => {
  try {
    const { id } = req.params;
    const { status } = req.body;

    if (!status) {
      return res.status(400).json({ message: "New status is required" });
    }

    const result = await db.query(
      `UPDATE orders
       SET status = $1
       WHERE orderid::text = $2 OR LOWER(order_code) = LOWER($2)
       RETURNING *`,
      [status.trim(), id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Order not found" });
    }

    res.json(formatOrder(result.rows[0]));
  } catch (err) {
    console.error("Update order status error:", err.message);
    res.status(500).json({ error: "Internal server error" });
  }
});

/**
 * DELETE /api/orders/:id
 * Protected by adminAuth
 */
router.delete("/:id", adminAuth, async (req, res) => {
  try {
    const { id } = req.params;
    const result = await db.query(
      "DELETE FROM orders WHERE orderid::text = $1 OR LOWER(order_code) = LOWER($1) RETURNING *",
      [id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Order not found" });
    }

    res.json({ message: "Order deleted", deleted: result.rows[0] });
  } catch (err) {
    console.error("Delete order error:", err.message);
    res.status(500).json({ error: "Internal server error" });
  }
});

export default router;
