require_relative '../lib/recipe'
require_relative '../lib/recipe_repository'

RSpec.describe RecipeRepository do
    def reset_recipes_table
        seed_sql = File.read('spec/seeds_recipes.sql')
        connection = PG.connect({host: '127.0.0.1', dbname: 'recipes_directory_test' })
        connection.exec(seed_sql)
    end

    before(:each) do
        reset_recipes_table
    end

    it 'Return a list of recipes' do

      repo = RecipeRepository.new
      recipes = repo.all

      expect(recipes.length).to eq(4)
      expect(recipes[0].id).to eq('1')
      expect(recipes[0].name).to eq('cheese on toast') 
      expect(recipes[0].cooking_time).to eq('5') 
      expect(recipes[0].rating).to eq('4') 

      expect(recipes[1].id).to eq('2') 
      expect(recipes[1].name).to eq('pasta') 
      expect(recipes[1].cooking_time).to eq('10') 
      expect(recipes[1].rating).to eq('3') 
    end
    
    it 'Returns a single Recipe' do

      repo = RecipeRepository.new
      recipe = repo.find(1)

      expect(recipe.id).to eq('1')
      expect(recipe.name).to eq ('cheese on toast')
      expect(recipe.cooking_time).to eq('5')
      expect(recipe.rating).to eq('4')
    end
end