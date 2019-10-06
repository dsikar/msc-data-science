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
We could build something like this:
```
  +------------------+
  | Prior Commitment |
  +-----+--------+---+
      Y |        | N
+-------+        +------+
|                       |
v                       v
                   +----+---+
N                  | Friend |
                   +-+----+-+
                   N |    | Y
                 +---+    +---+
                 |            |
                 v            v

                 N            Y

```
That is not the only solution, we could have starting with another attribute.
Intuitively, we would want the simplest possible model that would find the answer, that would translate into the shortest tree.  
We pick an attribute that will separate the data as much as possible, that is, will give us the most amount of information. In computing science this is known as *information gain* or *enthropy*:
![equation](http://latex.codecogs.com/gif.latex?O_t%3D%5Ctext%20%7B%20Onset%20event%20at%20time%20bin%20%7D%20t)
