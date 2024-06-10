const express = require('express');
const sqlite3 = require('sqlite3').verbose();
const bcrypt = require('bcryptjs');
const bodyParser = require('body-parser');

const db = new sqlite3.Database('./loginApp.db', (err) => {
  if (err) {
    console.error('Error opening database ' + err.message);
  } else {
    db.run('CREATE TABLE users (\
      id INTEGER PRIMARY KEY AUTOINCREMENT,\
      username TEXT UNIQUE,\
      password TEXT,\
      imagePath TEXT\
    )', (err) => {
      if (err) {
        console.log('Table already exists.');
      }
    });
  }
});

const app = express();
app.use(bodyParser.json());

app.post('/register', async (req, res) => {
  const { username, password } = req.body;
  const hashedPassword = await bcrypt.hash(password, 8);
  db.run('INSERT INTO users (username, password) VALUES (?, ?)', [username, hashedPassword], (err) => {
    if (err) {
      return res.status(400).send({ message: 'Could not register user' });
    }
    res.status(201).send({ message: "User registered successfully!" });
  });
});

app.post('/login', async (req, res) => {
  const { username, password } = req.body;
  db.get('SELECT * FROM users WHERE username = ?', [username], async (err, user) => {
    if (err || !user) {
      return res.status(404).send({ message: "User not found!" });
    }

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).send({ message: "Invalid credentials!" });
    }

    res.send({ message: "Logged in successfully!", imagePath: user.imagePath });
  });
});

app.post('/imagePath', (req, res) => {
  const { username, imagePath } = req.body;
  db.run('UPDATE users SET imagePath = ? WHERE username = ?', [imagePath, username], (err) => {
    if (err) {
      return res.status(400).send({ message: 'Could not update image path' });
    }
    res.send({ message: "Image path updated successfully!", imagePath });
  });
});

app.get('/imagePath/:username', (req, res) => {
  const { username } = req.params;
  db.get('SELECT imagePath FROM users WHERE username = ?', [username], (err, row) => {
    if (err || !row) {
      return res.status(404).send({ message: "User not found!" });
    }
    res.send({ imagePath: row.imagePath });
  });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
