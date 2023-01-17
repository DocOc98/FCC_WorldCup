#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE games, teams;")
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != "year" ]]
  then
    #Get team_winner_id
    TEAM_WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")
    #If not exist 
    if [[ -z $TEAM_WINNER_ID ]]
    then
      #Insert Winner
      INSERT_WINNER=$($PSQL "INSERT INTO teams(name) VALUES ('$WINNER');")
      if [[ $INSERT_WINNER == "INSERT 0 1" ]]
      then
        echo "Inserted $WINNER into teams."
      fi
      #Get new team_winner_id
      TEAM_WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")
    fi
    #Get team_opponent_id
    TEAM_OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")
    #If not exist 
    if [[ -z $TEAM_OPPONENT_ID ]]
    then
      #Insert Opponent
      INSERT_OPPONENT=$($PSQL "INSERT INTO teams(name) VALUES ('$OPPONENT');")
      if [[ $INSERT_OPPONENT == "INSERT 0 1" ]]
      then
        echo "Inserted $OPPONENT into teams."
      fi
      #Get new team_opponent_id
      TEAM_OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")
    fi
    #insert games
    INSERT_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $TEAM_WINNER_ID, $TEAM_OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS);")
    if [[ $INSERT_GAME == "INSERT 0 1" ]]
    then
      echo "Inserted Game in $ROUND."
    fi
  fi
done