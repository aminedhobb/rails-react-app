# Zombie App

This app uses a rails API providing endpoints to retrieve, create, update and destroy zombies. Each zombie can have several weapons and several armors. 
The client side is done entirely with React.

## Run the application locally

To run the application locally, you should run these commands (supposing you already created and migrated the db) :
```
  $ bundle install
  $ rails s
```

If you want to run the test do:

```
  $ bundle exec rspec
```

Here's the HTTP request you can run :

## Zombie API

To retrieve all the zombies present in the database, you need to do the following request : 
```bash
verb: GET
url: http://localhost:3000/api/v1/zombies
```

The response will have the following format:

```bash
{
  "data": [
    {
      "id": "521",
      "type": "zombie",
      "attributes": {
        "name": "Captain Evil Morty 135",
        "hit_points": 7,
        "speed": 3,
        "brains_eaten": 47,
        "turn_date": "2016-12-12T00:00:00.000Z",
        "user_id": 1,
        "weapons": [
          {
            "id": 521,
            "name": "Haptic xylophone 279",
            "attack_points": 9,
            "durability": 8,
            "price": 43,
            "created_at": "2018-11-25T16:53:13.000Z",
            "updated_at": "2018-11-25T16:53:13.000Z"
          }
        ],
        "armors": [
          {
            "id": 521,
            "name": "Tempeh helmet 737",
            "defense_points": 4,
            "durability": 10,
            "price": 23,
            "created_at": "2018-11-25T16:53:13.000Z",
            "updated_at": "2018-11-25T16:53:13.000Z"
          }
        ]
      }
    }
  ]
}
```

For all the requests I chose the JSON API format defined [here](https://jsonapi.org/).
I chose it because I'm already familiar with it and it brings homogenity to our API.

## Search for a zombie

You can search for specific zombies by adding a query to the url. You can search the zombies by name, by weapon name or by armor name. To do this I chose the `searchkick` gem that uses elastic search. I chose it for its efficiency and simplicity to use.

Here is an example if you search for the word `guitar` :
```bash
verb: GET
url: http://localhost:3000/api/v1/zombies?query=guitar
```

Then the response will have this format : 
```bash
{
  "data": [
    {
      "id": "381",
      "type": "zombie",
      "attributes": {
        "name": "Green Morty Smith 915",
        "hit_points": 3,
        "speed": 8,
        "brains_eaten": 15,
        "turn_date": "2017-09-08T00:00:00.000Z",
        "user_id": 42,
        "weapons": [
          {
            "id": 293,
            "name": "Auxiliary electric guitar 731",
            "attack_points": 7,
            "durability": 10,
            "price": 47,
            "created_at": "2018-11-23T15:04:30.000Z",
            "updated_at": "2018-11-23T15:04:30.000Z"
          }
        ],
        "armors": [
          {
            "id": 285,
            "name": "Tea oil shield 936",
            "defense_points": 8,
            "durability": 5,
            "price": 10,
            "created_at": "2018-11-23T15:04:30.000Z",
            "updated_at": "2018-11-23T15:04:30.000Z"
          }
        ]
      }
    },
    {
      "id": "387",
      "type": "zombie",
      "attributes": {
        "name": "Captain Revolio 'Gearhead' Clockberg, Jr. 414",
        "hit_points": 4,
        "speed": 3,
        "brains_eaten": 30,
        "turn_date": "2018-04-25T00:00:00.000Z",
        "user_id": 48,
        "weapons": [
          {
            "id": 299,
            "name": "Neural bass guitar 864",
            "attack_points": 6,
            "durability": 5,
            "price": 22,
            "created_at": "2018-11-23T15:04:31.000Z",
            "updated_at": "2018-11-23T15:04:31.000Z"
          }
        ],
        "armors": [
          {
            "id": 291,
            "name": "Blue cheese warmor 390",
            "defense_points": 2,
            "durability": 10,
            "price": 4,
            "created_at": "2018-11-23T15:04:31.000Z",
            "updated_at": "2018-11-23T15:04:31.000Z"
          }
        ]
      }
    }
  ]
}
```




## Create a zombie

To create a zombie you need to be logged in already.
If you want to create a new weapon, you have to pass its attributes in the `weapons_attributes` array field. If you want to add an existing weapon, you have to pass its id in the `weapon_ids`array field.
The armors work the same way as the weapons. Here is a request example for a zombie creation with a new weapon, a new armor and already existing armors.

```bash
verb POST
headers: Content-Type: application/vnd.api+json, Accept: application/vnd.api+json
url: http://localhost:3000/api/v1/zombies

body example: 
{
  "data": {
    "type": "zombie",
    "attributes": {
      "name": "Green Morty Smith 915",
      "hit_points": 3,
      "speed": 8,
      "brains_eaten": 15,
      "turn_date": "2017-09-08T00:00:00.000Z",
      "user_id": 42,
      "weapons_attributes": [
        {
          "name": "Auxiliary electric guitar 731",
          "attack_points": 7,
          "durability": 10,
          "price": 47
        }
      ],
      "armors_attributes": [
        {
          "name": "Tea oil shield 936",
          "defense_points": 8,
          "durability": 5,
          "price": 10
        }
      ],
      "armor_ids": [44, 53]
    }
  }
}
```

If the record is created, it will render in the respond body the created record in the same format, with the status `201`. If it fails, the response will have the status `422` with the corresponding error next to the key error in the body.

## Update a zombie 

You also need to be logged in to update a zombie. You pass the id of the zombie you want to update in the url. Here is a request example :

```bash
verb: PATCH or PUT
headers: Content-Type: application/vnd.api+json, Accept: application/vnd.api+json
url: http://localhost:3000/api/v1/zombies/:id
body: 
{
  "data": {
    "type": "zombie",
    "attributes": {
      "name": "new zombie name",
      "hit_points": 3,
      "speed": 8,
      "weapon_ids": [53],
      "armors_attributes": [
        {
          "name": "new armor",
          "defense_points": 8,
          "durability": 5,
          "price": 10,
        }
      ]  
    }
  }
}
```

If the record is updated, it will respond with the status `204` with no content. Otherwise the response will have the status `422` with the corresponding error next to the key error in the body.

## Destroy a zombie

You also need to be logged in to destroy a zombie. You pass the id of the zombie you want to destroy in the url. Here is a request example for zombie with id `203`:

```bash
verb: DELETE
url: http://localhost:3000/api/v1/zombies/:id
```

## React App

if you go the url of the website in your browser (local version or production version), you will access a react app that is consuming our API. You just need to login and then you can search or create a new zombie with new or existing weapon and armors.

