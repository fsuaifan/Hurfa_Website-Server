import express from "express";
import db from "../db/db.js";
import adminAuth from "../middleware/adminAuth.js";

const router = express.Router();

// Preset models mapping for detailed architectural showcases matching client data
// Architectural details mapping per model
const MODEL_DETAILS_MAP = {
  chic: [
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
  organic: [
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
  contemporary: [
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
};

function getSlugForKitchen(name, id) {
  const lower = (name || '').toLowerCase();
  if (lower.includes('organic')) return 'organic';
  if (lower.includes('chic')) return 'chic';
  if (lower.includes('contemporary')) return 'contemporary';
  if (id === 1) return 'contemporary';
  if (id === 2) return 'chic';
  if (id === 3) return 'organic';
  return String(id);
}

function getTitleForKitchen(name, id) {
  const lower = (name || '').toLowerCase();
  if (lower.includes('organic')) return 'Organic Modern';
  if (lower.includes('chic')) return 'Chic';
  if (lower.includes('contemporary')) return 'Contemporary';
  return name || `Kitchen Model ${id}`;
}

/**
 * GET /api/kitchens
 * Returns all kitchen models, dynamically querying kitchentype joined with kitchens variations
 */
router.get("/", async (req, res) => {
  try {
    const dbTypes = await db.query(
      `SELECT kt.*, 
        json_agg(
          json_build_object(
            'id', k.id, 
            'mainImg', k.mainimg, 
            'mainImage', k.mainimg, 
            'varImg', k.varimg, 
            'varImage', k.varimg
          ) ORDER BY k.id ASC
        ) FILTER (WHERE k.id IS NOT NULL) AS variations
       FROM kitchentype kt
       LEFT JOIN kitchens k ON kt.kitchentypeid = k.kitchentypeid AND (k.isvisible IS NULL OR k.isvisible = true)
       WHERE kt.isvisible = true
       GROUP BY kt.kitchentypeid
       ORDER BY kt.kitchentypeid ASC`
    );

    if (dbTypes.rows.length > 0) {
      const models = dbTypes.rows.map((row) => {
        const slug = getSlugForKitchen(row.kitchenname, row.kitchentypeid);
        const title = getTitleForKitchen(row.kitchenname, row.kitchentypeid);
        const variations = row.variations || [];
        const mainImg = row.img || variations[0]?.mainImg || "https://ik.imagekit.io/6dghafkgmq/Kitchens/Kit1V1.png";

        return {
          id: slug,
          dbId: row.kitchentypeid,
          title: title,
          name: title,
          eyebrow: "Model",
          desc: row.desc || `Experience the perfect blend of architectural style and functionality with our bespoke ${title} kitchen.`,
          mainImage: mainImg,
          mainImg: mainImg,
          variations: variations,
          details: MODEL_DETAILS_MAP[slug] || MODEL_DETAILS_MAP.chic,
        };
      });

      return res.json(models);
    }

    res.json([]);
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

    const dbResult = await db.query(
      `SELECT kt.*, 
        json_agg(
          json_build_object(
            'id', k.id, 
            'mainImg', k.mainimg, 
            'mainImage', k.mainimg, 
            'varImg', k.varimg, 
            'varImage', k.varimg
          ) ORDER BY k.id ASC
        ) FILTER (WHERE k.id IS NOT NULL) AS variations
       FROM kitchentype kt
       LEFT JOIN kitchens k ON kt.kitchentypeid = k.kitchentypeid AND (k.isvisible IS NULL OR k.isvisible = true)
       WHERE kt.kitchentypeid::text = $1 
          OR LOWER(kt.kitchenname) = $2
          OR ($2 = 'organic' AND LOWER(kt.kitchenname) LIKE '%organic%')
          OR ($2 = 'organic-modern' AND LOWER(kt.kitchenname) LIKE '%organic%')
          OR ($2 = 'contemporary' AND LOWER(kt.kitchenname) LIKE '%contemporary%')
          OR ($2 = 'chic' AND LOWER(kt.kitchenname) LIKE '%chic%')
       GROUP BY kt.kitchentypeid`,
      [id, lowerId]
    );

    if (dbResult.rows.length > 0) {
      const row = dbResult.rows[0];
      const slug = getSlugForKitchen(row.kitchenname, row.kitchentypeid);
      const title = getTitleForKitchen(row.kitchenname, row.kitchentypeid);
      const variations = row.variations || [];
      const mainImg = row.img || variations[0]?.mainImg || "https://ik.imagekit.io/6dghafkgmq/Kitchens/Kit1V1.png";

      return res.json({
        id: slug,
        dbId: row.kitchentypeid,
        title: title,
        name: title,
        eyebrow: "Model",
        desc: row.desc || `Experience the perfect blend of architectural style and functionality with our bespoke ${title} kitchen.`,
        mainImage: mainImg,
        mainImg: mainImg,
        variations: variations,
        details: MODEL_DETAILS_MAP[slug] || MODEL_DETAILS_MAP.chic,
      });
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
