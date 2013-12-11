User = require '../app/models/User'

User
  alias:'ishmael'
  email:'ishmaeltd@gmail.com'
  password:'Topolabs3d'
  isAdmin:true
  joined: new Date()
.save()

User
  alias:'james'
  email:'jamespage01@gmail.com'
  password:'Topolabs3d'
  isAdmin:true
  joined: new Date()
.save()

console.log 'Users created.'
