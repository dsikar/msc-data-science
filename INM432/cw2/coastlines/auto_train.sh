declare -a arr=("0.1" "0.2" "0.3" "0.4" "0.6" "0.7" "0.8" "0.9")

for i in "${arr[@]}"
do
   . auto_coastlines_train.sh "$i"
done
