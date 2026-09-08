import express from "express";
import db from "../db/db.js";
import adminAuth from "../middleware/adminAuth.js";

const router = express.Router();

// Preset models mapping for detailed architectural showcases matching client data
const DEFAULT_KITCHEN_MODELS = [
  {
    id: "chic",
    title: "Chic",
    eyebrow: "Model",
    tagline: "High-contrast finishes and clean hardware.",
    desc: "A bold, statement kitchen — high-contrast finishes and clean hardware for a space that stands out.",
    mainImage: "https://ik.imagekit.io/6dghafkgmq/Kitchens/Kit3V4.jpg?updatedAt=1779196664060",
    variations: [
      "https://ik.imagekit.io/6dghafkgmq/Kitchens/Kit3V4.jpg?updatedAt=1779196664060",
      "https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Wesal-Collection_n299cVlM5.jpg?updatedAt=1787138960280",
      "https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Tayf_4iPZv6iGf.png?updatedAt=1782466205843",
      "https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Oud-Collection_u9dsnBlwn.jpg?updatedAt=1787138978278",
    ],
    details: [
      {
        title: "Cabinetry",
        copy: "Soft-close hinges and hand-finished panel work, built to hold up to daily use without losing its edge.",
        image: "https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Wesal-Collection_n299cVlM5.jpg?updatedAt=1787138960280",
      },
      {
        title: "Surfaces",
        copy: "Countertop and backsplash materials chosen to match the tone of the model, with finishes that resist heat and stains.",
        image: "https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Tayf_4iPZv6iGf.png?updatedAt=1782466205843",
      },
    ],
  },
  {
    id: "organic",
    title: "Organic Modern",
    eyebrow: "Model",
    tagline: "Warm, natural materials and soft lines.",
    desc: "Warm, natural materials and soft lines — a kitchen that feels grounded and lived-in without giving up a modern edge.",
    mainImage: "https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Wesal-Collection_n299cVlM5.jpg?updatedAt=1787138960280",
    variations: [
      "https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Wesal-Collection_n299cVlM5.jpg?updatedAt=1787138960280",
      "https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Oud-Collection_u9dsnBlwn.jpg?updatedAt=1787138978278",
      "https://ik.imagekit.io/6dghafkgmq/Kitchens/Kit3V4.jpg?updatedAt=1779196664060",
    ],
    details: [
      {
        title: "Cabinetry",
        copy: "Constructed with natural wood grain panels, moisture-resistant sealing, and integrated push-to-open latches.",
        image: "https://ik.imagekit.io/6dghafkgmq/Kitchens/Kit3V4.jpg?updatedAt=1779196664060",
      },
      {
        title: "Surfaces",
        copy: "Honed natural stone countertops with matching waterfall edges for an unbroken, organic kitchen flow.",
        image: "https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Oud-Collection_u9dsnBlwn.jpg?updatedAt=1787138978278",
      },
    ],
  },
  {
    id: "contemporary",
    title: "Contemporary",
    eyebrow: "Model",
    tagline: "Minimal handles, flat panels, and a restrained palette.",
    desc: "Minimal handles, flat panels, and a restrained palette — built for a clean, uncluttered everyday kitchen.",
    mainImage: "https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Tayf_4iPZv6iGf.png?updatedAt=1782466205843",
    variations: [
      "https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Tayf_4iPZv6iGf.png?updatedAt=1782466205843",
      "https://ik.imagekit.io/6dghafkgmq/Kitchens/Kit3V4.jpg?updatedAt=1779196664060",
      "https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Oud-Collection_u9dsnBlwn.jpg?updatedAt=1787138978278",
      "https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Wesal-Collection_n299cVlM5.jpg?updatedAt=1787138960280",
    ],
    details: [
      {
        title: "Cabinetry",
        copy: "Architectural matte lacquer surfaces with seamless laser edge-banding that repels fingerprints and spills.",
        image: "https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Wesal-Collection_n299cVlM5.jpg?updatedAt=1787138960280",
      },
      {
        title: "Surfaces",
        copy: "Ultra-compact sintered porcelain counters engineered to withstand extreme heat, knife marks, and heavy daily cooking.",
        image: "https://ik.imagekit.io/6dghafkgmq/Kitchens/Kit3V4.jpg?updatedAt=1779196664060",
      },
    ],
  },
];

/**
 * GET /api/kitchens
 * Returns all kitchen models, dynamically merging kitchentype records with variation media
 */
router.get("/", async (req, res) => {
  try {
    const dbTypes = await db.query(
      `SELECT kt.*, 
        json_agg(json_build_object('id', k.id, 'mainimg', k.mainimg, 'varimg', k.varimg)) FILTER (WHERE k.id IS NOT NULL) AS variations
       FROM kitchentype kt
       LEFT JOIN kitchens k ON kt.kitchentypeid = k.kitchentypeid AND k.isvisible = true
       WHERE kt.isvisible = true
       GROUP BY kt.kitchentypeid
       ORDER BY kt.kitchentypeid ASC`
    );

    if (dbTypes.rows.length > 0) {
      const merged = DEFAULT_KITCHEN_MODELS.map((model) => {
        const matchingDb = dbTypes.rows.find(
          (t) =>
            t.kitchenname?.toLowerCase() === model.id.toLowerCase() ||
            t.kitchenname?.toLowerCase() === model.title.toLowerCase() ||
            (model.id === "organic" && t.kitchenname?.toLowerCase().includes("organic"))
        );

        if (matchingDb) {
          const dbImgs = (matchingDb.variations || [])
            .map((v) => v.varimg || v.mainimg)
            .filter(Boolean);

          return {
            ...model,
            dbId: matchingDb.kitchentypeid,
            mainImage: matchingDb.img || model.mainImage,
            desc: matchingDb.desc || model.desc,
            variations: dbImgs.length > 0 ? Array.from(new Set([matchingDb.img, ...dbImgs, ...model.variations].filter(Boolean))) : model.variations,
          };
        }
        return model;
      });

      return res.json(merged);
    }

    res.json(DEFAULT_KITCHEN_MODELS);
  } catch (err) {
    console.error("Fetch kitchens error:", err.message);
    res.status(500).json({ error: "Internal server error" });
  }
});

/**
 * GET /api/kitchens/types
 * Returns raw kitchentype records
 */
router.get("/types", async (req, res) => {
  try {
    const result = await db.query(
      "SELECT * FROM kitchentype WHERE isvisible = true ORDER BY kitchentypeid ASC"
    );
    res.json(result.rows);
  } catch (err) {
    console.error("Fetch kitchen types error:", err.message);
    res.status(500).json({ error: "Internal server error" });
  }
});

/**
 * GET /api/kitchens/:id
 * Supports slugs ('chic', 'organic', 'contemporary') or numeric ID
 */
router.get("/:id", async (req, res) => {
  try {
    const { id } = req.params;
    const lowerId = id.toLowerCase();

    const model = DEFAULT_KITCHEN_MODELS.find(
      (m) =>
        m.id.toLowerCase() === lowerId ||
        m.title.toLowerCase() === lowerId ||
        (lowerId === "organic-modern" && m.id === "organic")
    );

    if (model) {
      return res.json(model);
    }

    const dbResult = await db.query(
      `SELECT kt.*, json_agg(k.*) AS kitchens
       FROM kitchentype kt
       LEFT JOIN kitchens k ON kt.kitchentypeid = k.kitchentypeid
       WHERE kt.kitchentypeid::text = $1 OR LOWER(kt.kitchenname) = LOWER($1)
       GROUP BY kt.kitchentypeid`,
      [id]
    );

    if (dbResult.rows.length > 0) {
      return res.json(dbResult.rows[0]);
    }

    return res.status(404).json({ message: "Kitchen model not found" });
  } catch (err) {
    console.error("Get kitchen model error:", err.message);
    res.status(500).json({ error: "Internal server error" });
  }
});

/**
 * POST /api/kitchens
 * Protected by adminAuth
 */
router.post("/", adminAuth, async (req, res) => {
  try {
    const { kitchenname, desc, img, isvisible = true } = req.body;
    const result = await db.query(
      'INSERT INTO kitchentype (kitchenname, "desc", img, isvisible) VALUES ($1, $2, $3, $4) RETURNING *',
      [kitchenname, desc, img, isvisible]
    );
    res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error("Create kitchen error:", err.message);
    res.status(500).json({ error: "Internal server error" });
  }
});

/**
 * PUT /api/kitchens/:id
 * Protected by adminAuth
 */
router.put("/:id", adminAuth, async (req, res) => {
  try {
    const { id } = req.params;
    const { kitchenname, desc, img, isvisible } = req.body;

    const result = await db.query(
      `UPDATE kitchentype
       SET kitchenname = COALESCE($1, kitchenname),
           "desc" = COALESCE($2, "desc"),
           img = COALESCE($3, img),
           isvisible = COALESCE($4, isvisible)
       WHERE kitchentypeid = $5
       RETURNING *`,
      [kitchenname, desc, img, isvisible, id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Kitchen model not found" });
    }

    res.json(result.rows[0]);
  } catch (err) {
    console.error("Update kitchen error:", err.message);
    res.status(500).json({ error: "Internal server error" });
  }
});

/**
 * DELETE /api/kitchens/:id
 * Protected by adminAuth
 */
router.delete("/:id", adminAuth, async (req, res) => {
  try {
    const { id } = req.params;
    const result = await db.query(
      "DELETE FROM kitchentype WHERE kitchentypeid = $1 RETURNING *",
      [id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Kitchen model not found" });
    }

    res.json({ message: "Kitchen removed", deleted: result.rows[0] });
  } catch (err) {
    console.error("Delete kitchen error:", err.message);
    res.status(500).json({ error: "Internal server error" });
  }
});

export default router;
