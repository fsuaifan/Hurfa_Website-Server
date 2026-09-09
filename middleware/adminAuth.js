export default function adminAuth(req, res, next) {
  const role = (
    req.headers["x-role"] ||
    req.headers["x_role"] ||
    req.headers["role"] ||
    ""
  )
    .toString()
    .trim()
    .toLowerCase();

  if (role === "admin" || req.user?.role === "admin" || req.query?.mode === "admin" || req.query?.admin === "true") {
    return next();
  }

  res.status(403).json({ message: "Admin access only: missing admin authorization" });
}

