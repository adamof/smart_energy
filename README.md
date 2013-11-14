smart_energy_honours_project
============================

Smart energy meter web app. Honours project, Stefan Adamov

## Description of the project

The UK Smart Meter program will provide information displays in all UK households by 2020, which will show occupants the cost, carbon content and aamount of gas and electricity the dwelling is using. Various options will be available, for example current use and use accumulated over the last day, week, month and year.

For research projects which we hope will be of use to the Smart Meter program, we need a web application (possibly augmented by a phone app) that displays this kind of information. The goal of this software engineering project is to create this application.

The project will involve surveying the current displays provided with Smart Meters, and plans for future displays, to come up a set of requirements for the web application. Once the application is implemented, it will be evaluated with a variety of user groups for useability, and with Smart Meter providers for accuracy.

The application will be interactive, allowing users to explore their energy use in various ways (e.g., to see graphs in various forms). An extension could be to log useage and create views of these logs so that researchers can explore which displays are more often used by occupants.

We have datasets of energy consumption from homes to use for this project.

Because this is an easy project for someone with experience in web apps, it will need to be executed and written up very well to achieve a high mark. For this reason, and also because the app will be evaluated with ordinary people, a good command of written and spoken English is necessary.



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
