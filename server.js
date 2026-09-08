import express from "express";
import cors from "cors";
import morgan from "morgan";
import dotenv from "dotenv";
import db from "./db/db.js";
import errorHandler from "./middleware/errorHandler.js";

import authRoutes from "./routes/auth.js";
import productRoutes from "./routes/products.js";
import userRoutes from "./routes/users.js";
import kitchenRoutes from "./routes/kitchens.js";
import bedroomRoutes from "./routes/bedrooms.js";
import orderRoutes from "./routes/orders.js";
import clientRoutes from "./routes/clients.js";
import catalogRoutes from "./routes/catalog.js";
import categoryRoutes from "./routes/categories.js";

dotenv.config();

const app = express();
const PORT = process.env.PORT || 5000;

// Global Middlewares
app.use(cors());
app.use(express.json());
app.use(morgan("dev"));

// API Routes
app.use("/api/auth", authRoutes);
app.use("/api/products", productRoutes);
app.use("/api/users", userRoutes);
app.use("/api/kitchens", kitchenRoutes);
app.use("/api/bedrooms", bedroomRoutes);
app.use("/api/orders", orderRoutes);
app.use("/api/clients", clientRoutes);
app.use("/api/catalog", catalogRoutes);
app.use("/api/categories", categoryRoutes);

// Root Health Explorer Route
app.get("/", (req, res) => {
  res.json({
    status: "online",
    message: "🚀 Hurfa REST API Server is running",
    endpoints: {
      auth: "/api/auth",
      products: "/api/products",
      users: "/api/users",
      kitchens: "/api/kitchens",
      bedrooms: "/api/bedrooms",
      orders: "/api/orders",
      clients: "/api/clients",
      catalog: "/api/catalog",
      stats: "/api/catalog/stats",
      categories: "/api/categories",
    },
  });
});

// 404 Route Handler
app.use((req, res) => {
  res.status(404).json({ message: `Cannot ${req.method} ${req.url}` });
});

// Centralized Error Handler
app.use(errorHandler);

// Connect to Database and Start Server
db.connect()
  .then(() => {
    console.log("✅ Connected to the database successfully!");
    app.listen(PORT, () => {
      console.log(`🚀 Hurfa Server running at http://localhost:${PORT}`);
    });
  })
  .catch((err) => {
    console.error("❌ Database connection error:", err.message);
  });
