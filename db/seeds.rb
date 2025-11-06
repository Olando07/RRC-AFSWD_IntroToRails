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

# Add locations to types (fictional regions where these types are commonly found)
type_locations = {
  'Normal' => { lat: 40.7128, lng: -74.0060, location: 'New York City, USA' },
  'Fire' => { lat: -23.5505, lng: -46.6333, location: 'São Paulo, Brazil' },
  'Water' => { lat: -33.8688, lng: 151.2093, location: 'Sydney, Australia' },
  'Electric' => { lat: 35.6762, lng: 139.6503, location: 'Tokyo, Japan' },
  'Grass' => { lat: -3.4653, lng: -62.2159, location: 'Amazon Rainforest, Brazil' },
  'Ice' => { lat: 64.2008, lng: -149.4937, location: 'Fairbanks, Alaska' },
  'Fighting' => { lat: 22.3193, lng: 114.1694, location: 'Hong Kong' },
  'Poison' => { lat: 55.7558, lng: 37.6173, location: 'Moscow, Russia' },
  'Ground' => { lat: -23.4425, lng: -70.4487, location: 'Atacama Desert, Chile' },
  'Flying' => { lat: 27.1751, lng: 78.0421, location: 'Agra, India' },
  'Psychic' => { lat: 27.9881, lng: 86.9250, location: 'Mount Everest, Nepal' },
  'Bug' => { lat: -0.7893, lng: 113.9213, location: 'Borneo, Indonesia' },
  'Rock' => { lat: 36.0544, lng: -112.1401, location: 'Grand Canyon, USA' },
  'Ghost' => { lat: 51.5074, lng: -0.1278, location: 'London, UK' },
  'Dragon' => { lat: 39.9042, lng: 116.4074, location: 'Beijing, China' },
  'Dark' => { lat: 48.8566, lng: 2.3522, location: 'Paris, France' },
  'Steel' => { lat: 51.1657, lng: 10.4515, location: 'Berlin, Germany' },
  'Fairy' => { lat: 64.9631, lng: -19.0208, location: 'Iceland' }
}

type_locations.each do |type_name, data|
  type = Type.find_by(name: type_name)
  if type
    type.update(
      latitude: data[:lat],
      longitude: data[:lng],
      location_name: data[:location]
    )
  end
end
puts ""
puts "-----------------------------------------------------------------"
puts "Created locations for pokemons"
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
pokemon_response = URI.open("https://pokeapi.co/api/v2/pokemon?limit=150").read
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
30.times do 
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