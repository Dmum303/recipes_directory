# {{Recipes Directory}} Model and Repository Classes Design Recipe

As a food lover,
So I can stay organised and decide what to cook,
I'd like to keep a list of all my recipes with their names.

As a food lover,
So I can stay organised and decide what to cook,
I'd like to keep the average cooking time (in minutes) for each recipe.

As a food lover,
So I can stay organised and decide what to cook,
I'd like to give a rating to each of the recipes (from 1 to 5).

recipes 


## 1. Design and create the Table

If the table is already created in the database, you can skip this step.

Otherwise, [follow this recipe to design and create the SQL schema for your table](./single_table_design_recipe_template.md).

*In this template, well use an example table `students`*

```

Table: recipes

Columns:
id | int
name | text 
cooking_time | int
rating | int

CREATE TABLE recipes (
  id SERIAL PRIMARY KEY,
  name text,
  cooking_time int,
  rating int
);


```

## 2. Create Test SQL seeds

Your tests will depend on data stored in PostgreSQL to run.

If seed data is provided (or you already created it), you can skip this step.

```sql

file: spec/seeds_{recipes}.sql

TRUNCATE TABLE recipes RESTART IDENTITY;

-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.

INSERT INTO recipes (name, cooking_time, rating) VALUES ('cheese on toast', 5, 4);
INSERT INTO recipes (name, cooking_time, rating) VALUES ('pasta', 10, 3);
INSERT INTO recipes (name, cooking_time, rating) VALUES ('souffle', 30, 2);
INSERT INTO recipes (name, cooking_time, rating) VALUES ('chips', 15, 5);
```

Run this SQL file on the database to truncate (empty) the table, and insert the seed data. Be mindful of the fact any existing records in the table will be deleted.

to create database into psql CREATE DATABASE music_library_test;
then you can seed it with info, in order to do this you need to be in the directory containing seed file
psql -h 127.0.0.1 your_database_name < seeds_{table_name}.sql

```bash
psql -h 127.0.0.1 recipes_directory < seeds_recipes.sql
psql -h 127.0.0.1 recipes_directory_test < spec/seeds_recipes.sql  --from different directory
```
The above code is going to create database and put seed info in
Usually for tests we would need a 2 databases, the real one and a test
so we do not knack the real one during testing

Test database worked in psql SELECT * FROM recipes;

Need to change the DatabaseConnection.connect('databas_name') in app file to the test database ???? maybe not
actually needs to be in spec helper to change Need to change the DatabaseConnection.connect('databas_name')

## 3. Define the class names

Usually, the Model class name will be the capitalised table name (single instead of plural). The same name is then suffixed by `Repository` for the Repository class name.

```ruby
Table name: recipe

# Model class
# (in lib/recipet.rb)
class Recipe
end

# Repository class
# (in lib/recipe_repository.rb)
class RecipeRepository
end
```

## 4. Implement the Model class

Define the attributes of your Model class. You can usually map the table columns to the attributes of the class, including primary and foreign keys.

```ruby
# Table name: recipes

# Model class
# (in lib/recipe.rb)

class Recipe

  attr_accessor :id, :name, :cooking_time, :rating
end

```

*You may choose to test-drive this class, but unless it contains any more logic than the example above, it is probably not needed.*

## 5. Define the Repository Class interface

Your Repository class will need to implement methods for each "read" or "write" operation you'd like to run against the database.

Using comments, define the method signatures (arguments and return value) and what they do - write up the SQL queries that will be used by each method.

```ruby
# Table name: recipes

# Repository class
# (in lib/recipe_repository.rb)

class RecipeRepository

  # Selecting all records
  # No arguments
  def all
    # Executes the SQL query:
    SELECT id, name, cooking_time, rating FROM recipes;

    # Returns an array of Recipe objects.
  end

  # Gets a single record by its ID
  # One argument: the id (number)
  def find(id)
    # Executes the SQL query:
    SELECT id, name, cooking_time, rating FROM recipes WHERE id = $1;

    # Returns a single Recipe object.
  end

  # Add more methods below for each operation you'd like to implement.

  # def create(student)
  # end

  # def update(student)
  # end

  # def delete(student)
  # end
end
```

## 6. Write Test Examples

Write Ruby code that defines the expected behaviour of the Repository class, following your design from the table written in step 5.

These examples will later be encoded as RSpec tests.

```ruby
# EXAMPLES

# 1
# Get all students

repo = RecipeRepository.new

recipes = repo.all

recipes.length # => 4

recipes[0].id # =>  1
recipes[0].name # =>  'cheese on toast'
recipes[0].cooking_time # =>  '5'
recipes[0].rating # => '4'

recipes[1].id # =>  2
recipes[1].name # =>  'pasta'
recipes[1].cooking_time # =>  '10'
recipes[1].rating # =>  '3'
# 2
# Get a single student

repo = RecipeRepository.new

recipe = repo.find(1)

recipe.id # =>  1
recipe.name # =>  'cheese on toast'
recipe.cooking_time # =>  '5'
recipe.rating # => '4'

# Add more examples for each method
```

Encode this example as a test.

## 7. Reload the SQL seeds before each test run

Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

```ruby
# EXAMPLE

file: spec/recipe_repository_spec.rb

def reset_students_table
  seed_sql = File.read('spec/seeds_recipes.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'recipes' })
  connection.exec(seed_sql)
end

describe RecipeRepository do
  before(:each) do 
    reset_recipes_table
  end

  # (your tests will go here).
end
```

## 8. Test-drive and implement the Repository class behaviour

_After each test you write, follow the test-driving process of red, green, refactor to implement the behaviour._
