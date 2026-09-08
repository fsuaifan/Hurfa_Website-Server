import express from "express";
import cors from "cors";
import morgan from "morgan";
import dotenv from "dotenv";
import db from "./db/db.js";
import authRoutes from "./routes/auth.js";
import productRoutes from "./routes/products.js";
import userRoutes from "./routes/users.js";
import kitchenRoutes from "./routes/kitchens.js";
import bedroomRoutes from "./routes/bedrooms.js";
import orderRoutes from "./routes/orders.js";

dotenv.config();

const app = express();
const PORT = process.env.PORT || 5000;

// Global Middlewares
app.use(cors());
app.use(express.json());
app.use(morgan("dev"));

// Routes
app.use("/api/auth", authRoutes);
app.use("/api/products", productRoutes);
app.use("/api/users", userRoutes);
app.use("/api/kitchens", kitchenRoutes);
app.use("/api/bedrooms", bedroomRoutes);
app.use("/api/orders", orderRoutes);

// Root Test Route
app.get("/", (req, res) => {
  res.send("🚀 Hurfa API Server is running!");
});

// Connect to Database and Start Server
db.connect()
  .then(() => {
    console.log("✅ Connected to the database successfully!");
    app.listen(PORT, () => {
      console.log(`🚀 Server running on http://localhost:${PORT}`);
    });
  })
  .catch((err) => {
    console.error("❌ Database connection error:", err.message);
  });
