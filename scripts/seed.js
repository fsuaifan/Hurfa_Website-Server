import fs from "fs";
import path from "path";
import { fileURLToPath } from "url";
import db from "../db/db.js";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

async function seed() {
  try {
    console.log("🌱 Connecting to PostgreSQL Database for seeding...");
    await db.connect();

    const sqlPath = path.join(__dirname, "../schema.sql");
    const sqlContent = fs.readFileSync(sqlPath, "utf-8");

    console.log("📜 Executing schema.sql migration and seeding...");
    await db.query(sqlContent);

    console.log("✅ Database successfully initialized and seeded!");
    process.exit(0);
  } catch (err) {
    console.error("❌ Seeding failed:", err.message);
    process.exit(1);
  }
}

seed();
