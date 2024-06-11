const express = require('express');
const { PrismaClient } = require('@prisma/client');
const bodyParser = require('body-parser');
const bcrypt = require('bcrypt');

const prisma = new PrismaClient();
const app = express();
app.use(express.json());

// Get User Image Path
app.get('/imagePath/:username', async (req, res) => {
  const { username } = req.params;
  try {
    const user = await prisma.user.findUnique({
      where: {
        username: username,
      },
      select: {
        imagePath: true  // Only fetch imagePath
      }
    });

    if (user) {
      res.json({ imagePath: user.imagePath });
    } else {
      res.status(404).json({ message: "User not found" });
    }
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: error.message });
  }
});

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
    console.error(error);
    res.status(400).json({ error: error.message });
}
});

// Login User
 app.post('/login', async (req, res) => {
   const { username, password } = req.body;

   try {
     const user = await prisma.user.findUnique({
       where: {
         username: username,
       },
     });

     if (user && bcrypt.compareSync(password, user.password)) {
       res.json({ message: "Login successful", user });
     } else {
       res.status(401).json({ message: "Invalid credentials" });
     }
   } catch (error) {
     console.error(error);
     res.status(500).json({ error: error.message });
   }
 });

// User Image Path
app.post('/imagePath', async (req, res) => {
  const { username, imagePath } = req.body;
  try {
    const user = await prisma.user.update({
      where: {
        username: username,
      },
      data: {
        imagePath: imagePath,
      },
    });
    res.json({ message: "Image path for user", user });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: error.message });
  }
});

// Server running port
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
