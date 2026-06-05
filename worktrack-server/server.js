require('dotenv').config();
const express = require('express');
const cors = require('cors');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

// API Health
app.get('/api/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

// API Login
app.post('/api/auth/login', (req, res) => {
  const { email, password } = req.body;
  if (email === 'admin@worktrack.pro' && password === 'admin123') {
    res.json({ token: 'token_demo', user: { id: 1, email, first_name: 'Admin', last_name: 'Super', role: 'super_admin' } });
  } else if (email === 'manager@worktrack.pro' && password === 'manager123') {
    res.json({ token: 'token_demo', user: { id: 2, email, first_name: 'Marie', last_name: 'Martin', role: 'manager' } });
  } else {
    res.status(401).json({ error: 'Identifiants incorrects' });
  }
});

// API Dashboard
app.get('/api/dashboard/stats', (req, res) => {
  res.json({ presents: {total:45}, absents: {total:8}, retards: {total:3}, conges: {total:5} });
});

app.get('/api/dashboard/recent-pointages', (req, res) => {
  res.json([
    { employe: 'Jean Dupont', departement: 'IT', entree: '08:00', sortie: '17:00', duree: '9h00', statut: 'Présent' },
    { employe: 'Marie Martin', departement: 'RH', entree: '08:15', sortie: '17:00', duree: '8h45', statut: 'Retard' }
  ]);
});

app.get('/api/employees', (req, res) => {
  res.json([
    { id:1, first_name:'Jean', last_name:'Dupont', email:'jean@email.com', department:'IT', position:'Dev', status:'active' },
    { id:2, first_name:'Marie', last_name:'Martin', email:'marie@email.com', department:'RH', position:'Manager', status:'active' }
  ]);
});

// Servir Flutter
app.use(express.static(path.join(__dirname, 'web')));
app.get('*', (req, res) => {
  if (!req.url.startsWith('/api')) {
    res.sendFile(path.join(__dirname, 'web', 'index.html'));
  }
});

app.listen(PORT, () => console.log('🚀 WorkTrack Pro sur le port ' + PORT));
