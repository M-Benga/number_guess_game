#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo "Enter your username:"
read userName

# Check if username exist in database
USERNAME=$($PSQL "SELECT username FROM users WHERE username = '$userName' ")

# Handle the result if username exist or doesn't
if [[ -z $USERNAME ]]; then #username doesn't exist
 #Add username to database
USERADDED=$($PSQL "INSERT INTO users(username, best_game) VALUES('$userName', 1000) ")

echo "Welcome, $userName! It looks like this is your first time here."
else 
 # get his available info
GAMES_PLAYED=$($PSQL "SELECT games_played FROM users WHERE username = '$userName'")
BEST_GAME=$($PSQL "SELECT best_game FROM users WHERE username = '$userName'")

 echo "Welcome back, $userName! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
 fi
# We produce a random number btn 0 and 1000
randomNumber=$((RANDOM % 1000 + 1))
#echo "The random number between 1 and 1000 is: $randomNumber"

#random_number=$(awk -v min=1 -v max=1000 'BEGIN{srand(); print int(min + rand()*(max-min+1))}')

echo "Guess the secret number between 1 and 1000:"
read guessedNumber
numberOfGuesses=1


while [ $guessedNumber != $randomNumber ] ; do

  if [[ $guessedNumber =~ ^[-+]?[0-9]+$ ]]; then  # Check for valid integer

  if [ $guessedNumber -lt $randomNumber ]; then
    echo "It's higher than that, guess again:"
  else
    echo "It's lower than that, guess again:"
  fi
# else block executes if the first if condition fails (not an integer)
else
  echo "That is not an integer, guess again:"
fi

read guessedNumber

 numberOfGuesses=$(( numberOfGuesses + 1 ))
#echo "You have guessed $numberOfGuesses times." 

done

# Update database after the game
GAMES_PLAYED=$(( $GAMES_PLAYED + 1 ))
UPDATE_GAMES=$($PSQL "UPDATE users SET games_played = $GAMES_PLAYED WHERE username = '$userName'")

# get best game for next update
BEST_GAME=$($PSQL "SELECT best_game FROM users WHERE username = '$userName'")

if [ $numberOfGuesses -lt $BEST_GAME ]; then
 BEST_GAME=$numberOfGuesses 
 UPDATE_BEST_GAME=$($PSQL "UPDATE users SET best_game = $BEST_GAME WHERE username = '$userName' ")
 fi

echo "You guessed it in $numberOfGuesses tries. The secret number was $randomNumber. Nice job!"
