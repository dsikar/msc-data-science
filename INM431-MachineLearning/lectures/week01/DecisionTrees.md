# Decision Trees

* Very successful Machine Learning method, but not probabilistic
* Offers a graphical representation of a Boolean function (propositional logic formula) or a discrete function, in general

As an example of what a decision tree can do, let's look at a set of attributes that define a hyphothetical class "**Will attend party**".

|  | Prior commitment  | Distance   | Friend  |  Tired | Rain | Classification |
|---|---|---|---|---|---|---|
|1. |Y|L|N|Y|N|N|
|2. |N|M|N|Y|Y| N|
|3. |N|S|Y|Y|Y|Y|
|4. |N|S|N|Y|N|N|
|5. |N|M|Y|N|N|Y|
|6. |N|S|Y|Y|N|Y|
|7. |Y|S|Y|Y|N|N|
|8. |Y|M|Y|Y|Y|N|
|9. |Y|L|Y|Y|N|N|
|10.|Y|L|Y|Y|Y|N|

Our input is a set of properties, our output is the classification. We build a tree where the nodes are the attributes, the branches are the attribute values we are testing and the end nodes, or leaves, are the classifications.  
We could build something like this, we choose attribute *Prior commitment* as a node, and the attribute values *Y* and *N* as branches:
```
              +------------------+
              | Prior Commitment |
              +-----+--------+---+
                  Y |        | N  
            +-------+        +------+
            |                       |
            v                       v
```
We can then add the row numbers, with a sign to indicate the output.
```
              +------------------+
              | Prior Commitment |
              +-----+--------+---+
  -1,-7,-8,-9,-10 Y |        | N -2,+3,-4,+5,+6
            +-------+        +------+
            |                       |
            v                       v

            N
```

We see that for rows 1, 7, 8, 9 and 10, which have attribute values *Y*, that is to say, a prior commitment, have a classification value of *N*, so will not be attending the party. We add a leaf to that case, as no more tests are required, and move onto the other branch, which has a test for attribute value *N*. The rows 2, 3, 4, 5 and 6 have difference classifications, so we need to choose another node, that is, another attribute to test. We choose *Friend*:
```
              +------------------+
              | Prior Commitment |
              +-----+--------+---+
  -1,-7,-8,-9,-10 Y |        | N -2,+3,-4,+5,+6
            +-------+        +------+
            |                       |
            v                       v
                               +----+---+
            N                  | Friend |
                               +-+----+-+
                         -2,-4 N |    | Y +3,+5,+6
                             +---+    +---+
                             |            |
                             v            v

                             N            Y

```
We see that rows 2 and 4 are not friends of the host, so will not go to the party. We add a leaf and move onto the next branch.  We see that testing for *Y* results in a single classification of *Y*, so we add another leaf, and no further tests are required.  
That is not the only solution, we could have started with another attribute.
Intuitively, we would want the simplest possible model that would find the answer, that would translate into the shortest tree.  
We pick an attribute that will separate the data as much as possible, that is, will give us the most amount of information. In computing science this is known as *information gain* or *entropy*:    
**TODO**: Add entropy calculation
