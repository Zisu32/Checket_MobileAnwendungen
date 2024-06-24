const express = require('express');
const { PrismaClient } = require('@prisma/client');
const bcrypt = require('bcrypt');

const prisma = new PrismaClient();
const app = express();
app.use(express.json());

// Register User
app.post('/registration', async (req, res) => {
  const { username, password } = req.body;

  // Check if username already exists
  const existingUser = await prisma.user.findUnique({
    where: {
      username: username,
    },
  });

  if (existingUser) {
    return res.status(409).json({ message: "Benutzername schon vergeben" });
  }

  // Hash Password
  const hashedPassword = await bcrypt.hash(password, 10);
  try {
    const newUser = await prisma.user.create({
      data: {
        username,
        password: hashedPassword,
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

//create Jacket
app.post('/createJacket', async (req, res) => {
    const { jacketNumber, qrString, imagePath} = req.body;

    // Check if jacket already exists
    const existingjacketNumber = await prisma.jacket.findUnique({
      where: {
        jacketNumber: jacketNumber,
      },
    });

    if (existingjacketNumber) {
      return res.status(409).json({ message: "JacketNumber schon vergeben" });
    }

    // create jacket
    try {
      const newJacket = await prisma.jacket.create({
        data: {
          jacketNumber,
          qrString,
          imagePath,
        },
      });
      res.json(newJacket);
    } catch (error) {
      console.error(error);
      res.status(400).json({ error: error.message });
    }
  });

//update Jacket Status
app.put('/updateJacketStatus', async (req, res) => {
    const { jacketNumber, status } = req.body;

    // Check if jacket Number exists
    const number = await prisma.jacket.findUnique({
      where: {
        jacketNumber : jacketNumber,
      },
    });

    if (!number) {
      return res.status(409).json({ message: "Status konnte nicht aktualisiert werden!" });
    }
    console.log(typeof status)
    //update Jacket Status
    try {
      const updateJacketStatus = await prisma.jacket.update({
        where: {jacketNumber : jacketNumber},
        data: {status: status},
      });
      res.json(updateJacketStatus);
    } catch (error) {
      console.error(error);
      res.status(400).json({ error: error.message });
    }
  });

// Server running port
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});