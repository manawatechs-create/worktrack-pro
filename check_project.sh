#!/bin/bash
echo "🔍 VÉRIFICATION DU PROJET"
echo "========================"

cd ~/projects/gestion_presence

echo ""
echo "📁 Structure du projet :"
find lib -type f | sort

echo ""
echo "📦 Dépendances :"
~/flutter/bin/flutter pub get 2>&1 | tail -5

echo ""
echo "🔍 Analyse du code :"
~/flutter/bin/flutter analyze 2>&1 | tail -5

echo ""
echo "✅ Prêt pour le développement !"
