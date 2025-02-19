# mxrello
kanban for maintainx

# Setup

python 3.12

``` 
sudo apt install python3.12-venv 

python3 -m venv venv

source venv/bin/activate

pip install -r requirements.txt

```

## Note to Self

```
python manage.py makemigrations users
python manage.py migrate
python manage.py createsuperuser
python manage.py runserver
```

# Roadmap for MVP

## Phase 1: "Backend"

* [z] Get login/logout/signup working on local
    * [x] Make sure that we can manually modify passwords for users (password resets with email are complicated)
    * [x] Have a display to show a successful login
    * [?] Create relevant tests
    * [x] Create superuser admin
    * [x] Two different account types: superuser and user

* [x] On successful login, be directed to a "Hello, World" homepage

## Phase 2: One View For Mike

* [ ] Sort Options (default oldest to newest in terms of creation date)
* [ ] Lists by site location
* [ ] Dropdown checklist to exclude or include Bucks (default only maintenance)
* [ ] Dropdown checklist to exclude or include Bucks (default only colorado)

## Phase 3: Modals

* [ ] modal card with default data
* [ ] Make it look pretty but not too pretty


## Phase 4: Deployment

* [ ] Show boss, ask for approval to push it to prod
* [ ] Make sure both of these things work on production and are accessible through intr, with at least two users (admin and not admin)
* [ ] Deploy to Prod

# Ideas:

- openstreetview api integration to show by map

- create a url customizer

- make it look more like airtable

- custom tags

- "last updated" on the bottom right


## Customization

* [ ] Create a python.... thing that allows Kanban grouping by various different categories
* [ ] Add custom text to show up according to schema
* [ ] Add url-based category filters as well
* [ ] Add multilayered sorts
* [ ] Allow for exclusion of cards based on fields and boolean logic