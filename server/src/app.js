// Separate express and middleware from server functions
const path = require("path");
const express = require("express");
const cors = require("cors");
const morgan = require("morgan");

const api = require("./routes/api");

const app = express();

// Security
app.use(
  cors({
    origin: "http://localhost:3000",
  })
);

// Logging
app.use(morgan("combined"));

// Client serving
app.use(express.json());
app.use(express.static(path.join(__dirname, "..", "public")));

// Routes, order is sensitive (don't use catch all route before the others)
app.use("/v1", api);
app.get("/*", (req, res) => {
  res.sendFile(path.join(__dirname, "..", "public", "index.html"));
});

module.exports = { app };
