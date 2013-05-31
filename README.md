smart_energy_honours_project
============================

Smart energy meter web app. Honours project, Stefan Adamov

## Setup

- Install ruby-1.9.3-p125
- Install postgresql 9.1
- Install libpq-dev
- Download the zip file with the project
- cd smart_energy
- bundle install
- setup postgresql
- - open a postgres console
- - - sudo -u postgres psql postgres
- - create postgresql user smart_energy with password smart_energy
- - - CREATE USER smart_energy WITH PASSWORD 'smart_energy';
- - create postgresql database smart_energy owned by the smart_energy user
- - - CREATE DATABASE smart_energy OWNER smart_energy;
- rake db:migrate
- rake import
- create a user: email: sample@sample.net / password: password
- - rake create_user
- start the server
- - rails s
- go to localhost:3000