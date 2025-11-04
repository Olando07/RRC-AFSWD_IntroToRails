# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require "open-uri"
require "json"

PokemonTrainer.destroy_all
PokemonAbility.destroy_all
PokemonType.destroy_all
Trainer.destroy_all
Ability.destroy_all
Type.destroy_all
Pokemon.destroy_all

puts "🔥Fetching types from PokeAPI..."
types_response = URI.open("https://pokeapi.co/api/v2/type?limit=20").read
types_data = JSON.parse(types_response)["results"]

types_data.each do |type_data|
  Type.create!(name: type_data["name"].capitalize)
  print "."
end
puts ""
puts "-----------------------------------------------------------------"
puts "Created #{Type.count} pokemon types"
puts "-----------------------------------------------------------------"
puts ""


puts "⚡Fetching abilities from PokeAPI..."
abilities_response = URI.open("https://pokeapi.co/api/v2/ability?limit=50").read
abilities_data = JSON.parse(abilities_response)["results"]

abilities_data.each do |ability_data|
  abilities_detail_response = URI.open(ability_data["url"]).read
  abilities_detail = JSON.parse(abilities_detail_response)
  effect = abilities_detail.dig("effect_entries", 0, "short effect" || "No effect descriptions").to_s
  
  Ability.create!(name: ability_data["name"].split("-").map(&:capitalize).join(" "))
  print "."
end
puts ""
puts "-----------------------------------------------------------------"
puts "Created #{Ability.count} pokemon abilities"
puts "-----------------------------------------------------------------"
puts ""


puts "🎮Fetching pokemons from PokeAPI..."
pokemon_response = URI.open("https://pokeapi.co/api/v2/pokemon?limit=100").read
pokemon_list = JSON.parse(pokemon_response)["results"]

pokemon_list.each do |poke_data|
  begin
    details_response = URI.open(poke_data["url"]).read
    details = JSON.parse(details_response)
    
    pokemon = Pokemon.create!(
      name: details["name"].capitalize,
      height: details["height"],
      weight: details["weight"],
      base_experience: details["base_experience"],
      sprite_url: details.dig("sprites", "front_default")
      )
      
      # Add types
      details["types"].each do |type_info|
        type = Type.find_by(name: type_info["type"]["name"].capitalize)
        pokemon.types << type if type
    end
    
    # Add abilities
    details["abilities"].each do |ability_info|
      ability_name = ability_info["ability"]["name"].split("-").map(&:capitalize).join("")
      ability = Ability.find_by(name: ability_name) || "No description"
      pokemon.abilities << ability if ability
    end
    print "."
    
  rescue => e
    puts "\n Error with #{poke_data["name"]}: #{e}"
  end
end 
puts ""
puts "-----------------------------------------------------------------"
puts "Created #{Pokemon.count} pokemons"
puts "-----------------------------------------------------------------"
puts ""


puts "👤Creating trainers with Faker..."
20.times do 
  Trainer.create!(
    name: Faker::Name.name,
    hometown: Faker::Address.city
    )
  end
puts ""
puts "-----------------------------------------------------------------"
puts "Created #{Trainer.count} trainers"
puts "-----------------------------------------------------------------"
puts ""


puts "🤝Assigning pokemons to trainers..."
Trainer.all.each do |trainer|
  rand(3..6).times do
    pokemon = Pokemon.all.sample
    trainer.pokemons << pokemon unless trainer.pokemons.include?(pokemon)
  end
end
puts ""
puts "-----------------------------------------------------------------"
puts "Created #{PokemonTrainer.count} trainer-pokemon relationships"
puts "-----------------------------------------------------------------"
puts ""




puts "\n SEEDING COMPLETE!"
puts "📊 Summary:"
puts "  - #{Pokemon.count} Pokemon"
puts "  - #{Type.count} Types"
puts "  - #{Ability.count} Abilities"
puts "  - #{Trainer.count} Trainers"
puts "  - #{PokemonType.count} Pokemon-Type relationships"
puts "  - #{PokemonAbility.count} Pokemon-Ability relationships"
puts "  - #{PokemonTrainer.count} Pokemon-Trainer relationships"
puts "  - TOTAL ROWS: #{Pokemon.count + Type.count + Ability.count + Trainer.count + PokemonType.count + PokemonAbility.count + PokemonTrainer.count}"