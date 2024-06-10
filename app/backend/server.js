const express = require('express');
const { PrismaClient } = require('@prisma/client');
const bodyParser = require('body-parser');
const bcrypt = require('bcrypt');

const prisma = new PrismaClient();
const app = express();
app.use(express.json());


// Register User
app.post('/registration', async (req, res) => {
  const { username, password } = req.body;
  const hashedPassword = await bcrypt.hash(password, 10);  // Hash the password
  try {
    const newUser = await prisma.user.create({
      data: {
        username,
        password: hashedPassword,
        imagePath: ''
      },
    });
    res.json(newUser);
  } catch (error) {
    res.status(400).json({ error: "Could not create user." });
  }
});

// Login User
app.post('/login', async (req, res) => {
  const { username, password } = req.body; // Assume plaintext passwords for example
  const user = await prisma.user.findUnique({
    where: {
      username: username,
    },
  });

  if (user && user.password === password) {
    res.json({ message: "Login successful", user });
  } else {
    res.status(401).json({ message: "Invalid credentials" });
  }
});

// Server running port
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
