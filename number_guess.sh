#!/bin/bash

echo "Enter your username:"
read userName

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

echo "You guessed it in $numberOfGuesses tries. The secret number was $randomNumber. Nice job!"

