---
title: Pandas DataFrames
teaching: 15
exercises: 15
questions:
- How can I do statistical analysis of tabular data?
objectives:
- Select individual values from a Pandas dataframe.
- Select entire rows or entire columns from a dataframe.
- Select a subset of both rows and columns from a dataframe in a single operation.
- Select a subset of a dataframe by a single Boolean criterion.
keypoints:
- Use `DataFrame.iloc[..., ...]` to select values by integer location.
- Use `:` on its own to mean all columns or all rows.
- Select multiple columns or rows using `DataFrame.loc` and a named slice.
- Result of slicing can be used in further operations.
- Use comparisons to select data based on value.
- Select values or NaN using a Boolean mask.
---

{% include links.md %}

## Note about Pandas DataFrames and Series

A [DataFrame][pandas-dataframe] is a collection of [Series][pandas-series]. The DataFrame is the way Pandas represents a table, and Series is the data-structure Pandas use to represent a column.

Pandas is built on top of [Numpy][numpy], a scientific computing library for performing fast numerical operations on arrays. In practice, this means that most of the methods defined for Numpy Arrays apply to Pandas Series/DataFrames. 

What makes Pandas so attractive is the powerful interface to access individual records of the table, proper handling of missing values, and relational-database operations between DataFrames, like joining and merging on an index.

## Selecting values

To access the value at the position `[i,j]` of a DataFrame, we have two options, depending on what meaning of `i` is in use. Remember that a DataFrame has an *index* as a way to identify the rows of the table; a row, then, has as a *label*, but it also has a *position* inside the table.

## Use `DataFrame.iloc[..., ...]` to select values by their (entry) position

Regardless of the choice of index labels, Pandas automatically maintains a numerical index that keeps track of the *position* of rows by numbering them from `0` to `n` (where n is one less than the number of rows in the DataFrame). We can access elements by position using the function `iloc[]`

```python
import pandas as pd

europe_gdp = pd.read_csv('data/gapminder_gdp_europe.csv', index_col='country')
print(europe_gdp.iloc[0, 0])
```

```output
1601.056136
```

Notice that `iloc[]` takes the position in square brackets. This is different from other functions in Python. 

## Get multiple values by passing a list of positions

If we give `iloc` a list of positions for each dimension, we'll get back a dataframe containing just the values at the combination of those positions:

```python
print(europe_gdp.iloc[[0, -1], [0, -1]])
```

```output
                gdpPercap_1952  gdpPercap_2007
country                                       
Albania            1601.056136     5937.029526
United Kingdom     9979.508487    33203.261280
```

What if we use a list for one dimension, and a single value for the other? The data we get back is 1-dimensional - so it's a Series. 

```python
print(europe_gdp.iloc[0, [0, -1]])
```

```output
gdpPercap_1952    1601.056136
gdpPercap_2007    5937.029526
Name: Albania, dtype: float64
```

Note that, perhaps slightly confusingly, we can get the *same* data in a dataframe with a single row, by passing a list with a single value:

```python
print(europe_gdp.iloc[[0], [0, -1]])
```

```output
         gdpPercap_1952  gdpPercap_2007
country                                
Albania     1601.056136     5937.029526
```

Note that `-1` denotes the last position, `-2` would eb the second-last, and so on. This is the same as list indexing in Python.

## Use `DataFrame.loc[..., ...]` to select values by their (entry) label.

Often we want to access data using a more meaningful label than the position of the row - this is what the index is for. We can specify location by row and/or column name, using the function `loc[]`:

```python
print(data.loc["Albania", "gdpPercap_1952"])
```

```output
1601.056136
```

Again, note that we pass the index labels to `loc[]` in square brackets, not round ones. 

Like with `iloc[]`, we can past lists of labels to loc to get back multiple values.

```python
eastern_europe = ['Albania', 'Bosnia and Herzegovina', 'Bulgaria', 'Croatia', 'Czech Republic', 'Hungary', 'Montenegro', 'Poland', 'Romania', 'Serbia', 'Slovakia', 'Slovenia']

eighties = ['gdpPercap_1982', 'gdpPercap_1987']

print(europe_gdp.loc[eastern_europe, eighties])
```

```output
                        gdpPercap_1982  gdpPercap_1987
country                                               
Albania                    3630.880722     3738.932735
Bosnia and Herzegovina     4126.613157     4314.114757
Bulgaria                   8224.191647     8239.854824
Croatia                   13221.821840    13822.583940
Czech Republic            15377.228550    16310.443400
Hungary                   12545.990660    12986.479980
Montenegro                11222.587620    11732.510170
Poland                     8451.531004     9082.351172
Romania                    9605.314053     9696.273295
Serbia                    15181.092700    15870.878510
Slovak Republic           11348.545850    12037.267580
Slovenia                  17866.721750    18678.534920
```

## Get a slice of data with a colon `:`

We can slice data in a dataframe or series, the same as in a Python list. 

Let's go back to thinking about accessing data by position with `iloc`. We can specify a range of values using a colon `:`. This is called a slice:

```python
print(europe_gdp.iloc[0:2, 0:2])
```

```output
         gdpPercap_1997  gdpPercap_2002
country                                
Albania     3193.054604     4604.211737
Austria    29095.920660    32417.607690
```

> ## A slice with `iloc` does **not** include the second value in the range
> 
> Slicing using `iloc[start:stop]` returns a range of values at the positions `start` to `stop-1`. 
{: .callout}

This behaves just like list indexing in Python:

- If we omit a value on either side of the colon, the range will extend to the end - so `:10` is equivalent to `0:10`.
- If we want the last five elements, we can use `-5:`.
- A colon `:` with no endpoints indicates the whole range

## You can also slice data by index label with `loc[]`

We can use slices on labels too, but the behaviour is slightly different.

This prints the row for Albania:

```python
print(europe_gdp.loc["Albania", :])
```

```output
gdpPercap_1952    1601.056136
gdpPercap_1957    1942.284244
gdpPercap_1962    2312.888958
gdpPercap_1967    2760.196931
gdpPercap_1972    3313.422188
gdpPercap_1977    3533.003910
gdpPercap_1982    3630.880722
gdpPercap_1987    3738.932735
gdpPercap_1992    2497.437901
gdpPercap_1997    3193.054604
gdpPercap_2002    4604.211737
gdpPercap_2007    5937.029526
Name: Albania, dtype: float64
```

Note that this outputs a series. 

We would get the same result printing `europe_gdp.loc["Albania"]` (without indexing the second dimension).

To print a whole column, use a `:` for the first dimension (the row index). 

```python
print(europe_gdp.loc[:, "gdpPercap_1952"])
```

```output
country
Albania                    1601.056136
Austria                    6137.076492
Belgium                    8343.105127
⋮ ⋮ ⋮
Switzerland               14734.232750
Turkey                     1969.100980
United Kingdom             9979.508487
Name: gdpPercap_1952, dtype: float64
```

- You would get the same result with `europe_gdp["gdpPercap_1952"]` - this is not recommended for accessing columns, because `loc` is more explicit and behaves more predictably. This is a confusing technical point. For now, know that it's usually best to use `loc`
- You could also get the same result with `europe_gdp.gdpPercap_1952` - this is not recommended, because it's easily confused with `.` notation for methods

## Select multiple columns or rows using `DataFrame.loc` and a named slice.

We can slice a range of labels using the colon `:` operator.

```python
print(data.loc['Italy':'Poland', 'gdpPercap_1962':'gdpPercap_1972'])
```

```output
             gdpPercap_1962  gdpPercap_1967  gdpPercap_1972
country
Italy           8243.582340    10022.401310    12269.273780
Montenegro      4649.593785     5907.850937     7778.414017
Netherlands    12790.849560    15363.251360    18794.745670
Norway         13450.401510    16361.876470    18965.055510
Poland          5338.752143     6557.152776     8006.506993
```

Note that the slice is based on the pre-existing order of the index. Our countries are in alphabetical order, but that's because the data we used was already organised that way. The label index is not guaranteed to be sorted in any intuitive way, so take care when slicing using `loc`.

> ## A slice with `loc` **does** include the second value in the range
> 
> In the above code, we discover that **slicing using `loc` is inclusive at both ends**, which differs from **slicing using `iloc`**, where slicing indicates everything up to but not including the final index.
{: .callout}

## Result of slicing can be used in further operations.

We usually don't just want to print a slice - we want to perform some calcuations on it. All the statistical operators that work on entire dataframes work the same way on slices.

For example, we can calculate the maximum values in a slice.

```python
print(data.loc['Italy':'Poland', 'gdpPercap_1962':'gdpPercap_1972'].max())
```

```output
gdpPercap_1962    13450.40151
gdpPercap_1967    16361.87647
gdpPercap_1972    18965.05551
dtype: float64
```

```python
print(data.loc['Italy':'Poland', 'gdpPercap_1962':'gdpPercap_1972'].min())
```

```output
gdpPercap_1962    4649.593785
gdpPercap_1967    5907.850937
gdpPercap_1972    7778.414017
dtype: float64
```

## Use comparisons to find data based on its value.

We can apply comparisons to dataframes element-by-element using boolean operators. This returns a returns a similarly-shaped dataframe of `True` and `False`.

```python
# Use a subset of data to keep output readable.
northern_europe = ['Denmark', 'Finland', 'Iceland', 'Norway', 'Sweden']

northern_eighties_gdp = europe_gdp.loc[northern_europe, eighties]
print('Subset of data:\n', northern_eighties_gdp)

# Which values were greater than 25000?
print('\nWhere are values large?\n', northern_eighties_gdp > 25000)
```

```output
Subset of data:
          gdpPercap_1982  gdpPercap_1987
country                                
Denmark     21688.04048     25116.17581
Finland     18533.15761     21141.01223
Iceland     23269.60750     26923.20628
Norway      26298.63531     31540.97480
Sweden      20667.38125     23586.92927

Where are values large?
          gdpPercap_1982  gdpPercap_1987
country                                
Denmark           False            True
Finland           False           False
Iceland           False            True
Norway             True            True
Sweden            False           False
```

There are lots of operators and functions that can be used to return boolean values. Some common ones are:

- `<`: "less than"
- `>`: "greater than"
- `==`: "equal to" (note the double equals symbol!)
- `<=`: "less than or equal to"
- `>=`: "greater than or equal to"
- `!=`: "not equal to"


## Select values or NaN using a Boolean mask.

We can use this dataframe of boolean values to select data from the original dataframe. A frame full of booleans is sometimes called a *mask* because of how it can be used.

This time we'll use just the square brackets to apply the mask, without `loc` or `iloc`.

```python
high_gdp_mask = northern_eighties_gdp > 25000
print(northern_eighties_gdp[high_gdp_mask])
```

```output
             gdpPercap_1962  gdpPercap_1967  gdpPercap_1972
country
Italy                   NaN     10022.40131     12269.27378
Montenegro              NaN             NaN             NaN
Netherlands     12790.84956     15363.25136     18794.74567
Norway          13450.40151     16361.87647     18965.05551
Poland                  NaN             NaN             NaN
```

We get back the values where the mask is true, and `NaN` (Not a Number) where it is false.
This is useful because `NaN`s are ignored by operations like max, min, average, etc.

```python
print(northern_eighties_gdp[high_gdp_mask].describe())
```

```output
       gdpPercap_1982  gdpPercap_1987
count         1.00000        3.000000
mean      26298.63531    27860.118963
std               NaN     3313.286065
min       26298.63531    25116.175810
25%       26298.63531    26019.691045
50%       26298.63531    26923.206280
75%       26298.63531    29232.090540
max       26298.63531    31540.974800
```

## Combine multiple criteria in a single mask

We can create more complex masks by combining boolean operations. 

```python
print(northern_eighties_gdp[(northern_eighties_gdp > 25000) & (northern_eighties_gdp < 30000)])
```

```output
         gdpPercap_1982  gdpPercap_1987
country                                
Denmark             NaN     25116.17581
Finland             NaN             NaN
Iceland             NaN     26923.20628
Norway      26298.63531             NaN
Sweden              NaN             NaN
```

Note that separate criteria must be contained in their own set of round brackets`()`. 

The symbols for logical operations in Python are:

- `|`: "or"
- `&`: "and"
- `~`: "not"


> ## Selection of Individual Values
> 
> Assume Pandas has been imported into your notebook
> and the Gapminder GDP data for Europe has been loaded:
> 
> ```python
> import pandas as pd
> 
> data_europe = pd.read_csv('data/gapminder_gdp_europe.csv', index_col='country')
> ```
> 
> Write an expression to find the Per Capita GDP of Serbia in 2007.
> 
> > ## Solution
> > 
> > The selection can be done by using the labels for both the row ("Serbia") and the column ("gdpPercap\_2007"):
> > 
> > ```python
> > print(data_europe.loc['Serbia', 'gdpPercap_2007'])
> > ```
> > 
> > The output is
> > 
> > ```output
> > 9786.534714
> > ```
> {: .solution}
{: .challenge}


> ## Extent of Slicing
> 
> 1. Do the two statements below produce the same output?
> 2. Based on this,
>   what rule governs what is included (or not) in numerical slices and named slices in Pandas?
> 
> ```python
> print(data_europe.iloc[0:2, 0:2])
> print(data_europe.loc['Albania':'Belgium', 'gdpPercap_1952':'gdpPercap_1962'])
> ```
> 
> > ## Solution
> > 
> > No, they do not produce the same output! The output of the first statement is:
> > 
> > ```output
> >         gdpPercap_1952  gdpPercap_1957
> > country                                
> > Albania     1601.056136     1942.284244
> > Austria     6137.076492     8842.598030
> > ```
> > 
> > The second statement gives:
> > 
> > ```output
> >         gdpPercap_1952  gdpPercap_1957  gdpPercap_1962
> > country                                                
> > Albania     1601.056136     1942.284244     2312.888958
> > Austria     6137.076492     8842.598030    10750.721110
> > Belgium     8343.105127     9714.960623    10991.206760
> > ```
> > 
> > Clearly, the second statement produces an additional column and an additional row compared to the first statement.  
> > What conclusion can we draw? We see that a numerical slice, 0:2, *omits* the final index (i.e. index 2)
> > in the range provided,
> > while a named slice, 'gdpPercap\_1952':'gdpPercap\_1962', *includes* the final element.
> {: .solution}
{: .challenge}



> ## Reconstructing Data
> 
> Explain what each line in the following short program does:
> what is in `first`, `second`, etc.?
> 
> ```python
> first = pd.read_csv('data/gapminder_all.csv', index_col='country')
> second = first[first['continent'] == 'Americas']
> third = second.drop('Puerto Rico')
> fourth = third.drop('continent', axis = 1)
> fourth.to_csv('result.csv')
> ```
> 
> > ## Solution
> > 
> > Let's go through this piece of code line by line.
> > 
> > ```python
> > first = pd.read_csv('data/gapminder_all.csv', index_col='country')
> > ```
> > 
> > This line loads the dataset containing the GDP data from all countries into a dataframe called
> > `first`. The `index_col='country'` parameter selects which column to use as the
> > row labels in the dataframe.
> > 
> > ```python
> > second = first[first['continent'] == 'Americas']
> > ```
> > 
> > This line makes a selection: only those rows of `first` for which the 'continent' column matches
> > 'Americas' are extracted. Notice how the Boolean expression inside the brackets,
> > `first['continent'] == 'Americas'`, is used to select only those rows where the expression is true.
> > Try printing this expression! Can you print also its individual True/False elements?
> > (hint: first assign the expression to a variable)
> > 
> > ```python
> > third = second.drop('Puerto Rico')
> > ```
> > 
> > As the syntax suggests, this line drops the row from `second` where the label is 'Puerto Rico'. The
> > resulting dataframe `third` has one row less than the original dataframe `second`.
> > 
> > ```python
> > fourth = third.drop('continent', axis = 1)
> > ```
> > 
> > Again we apply the drop function, but in this case we are dropping not a row but a whole column.
> > To accomplish this, we need to specify also the `axis` parameter (we want to drop the second column
> > which has index 1).
> > 
> > ```python
> > fourth.to_csv('result.csv')
> > ```
> > 
> > The final step is to write the data that we have been working on to a csv file. Pandas makes this easy
> > with the `to_csv()` function. The only required argument to the function is the filename. Note that the
> > file will be written in the directory from which you started the Jupyter or Python session.
> {: .solution}
{: .challenge}


> ## Selecting Indices
> 
> Explain in simple terms what `idxmin` and `idxmax` do in the short program below.
> When would you use these methods?
> 
> ```python
> data = pd.read_csv('data/gapminder_gdp_europe.csv', index_col='country')
> print(data.idxmin())
> print(data.idxmax())
> ```
> 
> > ## Solution
> > 
> > For each column in `data`, `idxmin` will return the index value corresponding to each column's minimum;
> > `idxmax` will do accordingly the same for each column's maximum value.
> > 
> > You can use these functions whenever you want to get the row index of the minimum/maximum value and not the actual minimum/maximum value.
> {: .solution}
{: .challenge}


> ## Practice with Selection
> 
> Assume Pandas has been imported and the Gapminder GDP data for Europe has been loaded.
> Write an expression to select each of the following:
> 
> 1. GDP per capita for all countries in 1982.
> 2. GDP per capita for Denmark for all years.
> 3. GDP per capita for all countries for years *after* 1985.
> 4. GDP per capita for each country in 2007 as a multiple of
>   GDP per capita for that country in 1952.
> 
> > ## Solution
> > 
> > 1:
> > 
> > ```python
> > data['gdpPercap_1982']
> > ```
> > 
> > 2:
> > 
> > ```python
> > data.loc['Denmark',:]
> > ```
> > 
> > 3:
> > 
> > ```python
> > data.loc[:,'gdpPercap_1985':]
> > ```
> > 
> Pandas is smart enough to recognize the number at the end of the column label and does not give you an error, although no > column named `gdpPercap_1985` actually exists. This is useful if new columns are added to the CSV file later.
> > 
> > 4:
> > 
> > ```python
> > data['gdpPercap_2007']/data['gdpPercap_1952']
> > ```
> {: .solution}
{: .challenge}


> ## Many Ways of Access
> 
> There are at least two ways of accessing a value or slice of a DataFrame: by name or index.
> However, there are many others. For example, a single column or row can be accessed either as a `DataFrame`
> or a `Series` object.
> 
> Suggest different ways of doing the following operations on a DataFrame:
> 
> 1. Access a single column
> 2. Access a single row
> 3. Access an individual DataFrame element
> 4. Access several columns
> 5. Access several rows
> 6. Access a subset of specific rows and columns
> 7. Access a subset of row and column ranges
> 
> > ## Solution
> > 
> > 1\. Access a single column:
> > 
> > ```python
> > # by name
> > data["col_name"]   # as a Series
> > data[["col_name"]] # as a DataFrame
> > 
> > # by name using .loc
> > data.T.loc["col_name"]  # as a Series
> > data.T.loc[["col_name"]].T  # as a DataFrame
> > 
> > # Dot notation (Series)
> > data.col_name
> > 
> > # by index (iloc)
> > data.iloc[:, col_index]   # as a Series
> > data.iloc[:, [col_index]] # as a DataFrame
> > 
> > # using a mask
> > data.T[data.T.index == "col_name"].T
> > ```
> > 
> > 2\. Access a single row:
> > 
> > ```python
> > # by name using .loc
> > data.loc["row_name"] # as a Series
> > data.loc[["row_name"]] # as a DataFrame
> > 
> > # by name
> > data.T["row_name"] # as a Series
> > data.T[["row_name"]].T # as a DataFrame
> > 
> > # by index
> > data.iloc[row_index]   # as a Series
> > data.iloc[[row_index]]   # as a DataFrame
> > 
> > # using mask
> > data[data.index == "row_name"]
> > ```
> > 
> > 3\. Access an individual DataFrame element:
> > 
> > ```python
> > # by column/row names
> > data["column_name"]["row_name"]         # as a Series
> > 
> > data[["col_name"]].loc["row_name"]  # as a Series
> > data[["col_name"]].loc[["row_name"]]  # as a DataFrame
> > 
> > data.loc["row_name"]["col_name"]  # as a value
> > data.loc[["row_name"]]["col_name"]  # as a Series
> > data.loc[["row_name"]][["col_name"]]  # as a DataFrame
> > 
> > data.loc["row_name", "col_name"]  # as a value
> > data.loc[["row_name"], "col_name"]  # as a Series. Preserves index. Column name is moved to `.name`.
> > data.loc["row_name", ["col_name"]]  # as a Series. Index is moved to `.name.` Sets index to column name.
> > data.loc[["row_name"], ["col_name"]]  # as a DataFrame (preserves original index and column name)
> > 
> > # by column/row names: Dot notation
> > data.col_name.row_name
> > 
> > # by column/row indices
> > data.iloc[row_index, col_index] # as a value
> > data.iloc[[row_index], col_index] # as a Series. Preserves index. Column name is moved to `.name`
> > data.iloc[row_index, [col_index]] # as a Series. Index is moved to `.name.` Sets index to column name.
> > data.iloc[[row_index], [col_index]] # as a DataFrame (preserves original index and column name)
> > 
> > # column name + row index
> > data["col_name"][row_index]
> > data.col_name[row_index]
> > data["col_name"].iloc[row_index]
> > 
> > # column index + row name
> > data.iloc[:, [col_index]].loc["row_name"]  # as a Series
> > data.iloc[:, [col_index]].loc[["row_name"]]  # as a DataFrame
> > 
> > # using masks
> > data[data.index == "row_name"].T[data.T.index == "col_name"].T
> > ```
> > 
> > 4\. Access several columns:
> > 
> > ```python
> > # by name
> > data[["col1", "col2", "col3"]]
> > data.loc[:, ["col1", "col2", "col3"]]
> > 
> > # by index
> > data.iloc[:, [col1_index, col2_index, col3_index]]
> > ```
> > 
> > 5\. Access several rows
> > 
> > ```python
> > # by name
> > data.loc[["row1", "row2", "row3"]]
> > 
> > # by index
> > data.iloc[[row1_index, row2_index, row3_index]]
> > ```
> > 
> > 6\. Access a subset of specific rows and columns
> > 
> > ```python
> > # by names
> > data.loc[["row1", "row2", "row3"], ["col1", "col2", "col3"]]
> > 
> > # by indices
> > data.iloc[[row1_index, row2_index, row3_index], [col1_index, col2_index, col3_index]]
> > 
> > # column names + row indices
> > data[["col1", "col2", "col3"]].iloc[[row1_index, row2_index, row3_index]]
> > 
> > # column indices + row names
> > data.iloc[:, [col1_index, col2_index, col3_index]].loc[["row1", "row2", "row3"]]
> > ```
> > 
> > 7\. Access a subset of row and column ranges
> > 
> > ```python
> > # by name
> > data.loc["row1":"row2", "col1":"col2"]
> > 
> > # by index
> > data.iloc[row1_index:row2_index, col1_index:col2_index]
> > 
> > # column names + row indices
> > data.loc[:, "col1_name":"col2_name"].iloc[row1_index:row2_index]
> > 
> > # column indices + row names
> > data.iloc[:, col1_index:col2_index].loc["row1":"row2"]
> > ```
> {: .solution}
{: .challenge}


> ## Exploring available methods using the `dir()` function
> 
> Python includes a `dir()` function that can be used to display all of the available methods (functions) that are built into a data object.  In Episode 4, we used some methods with a string. But we can see many more are available by using `dir()`:
> 
> ```python
> my_string = 'Hello world!'   # creation of a string object 
> dir(my_string)
> ```
> 
> This command returns:
> 
> ```python
> ['__add__',
> ...
> '__subclasshook__',
> 'capitalize',
> 'casefold',
> 'center',
> ...
> 'upper',
> 'zfill']
> ```
> 
> You can use `help()` or <kbd>Shift</kbd>\+<kbd>Tab</kbd> to get more information about what these methods do.
> 
> Assume Pandas has been imported and the Gapminder GDP data for Europe has been loaded as `data`.  Then, use `dir()`
> to find the function that prints out the median per-capita GDP across all European countries for each year that information is available.
> 
> > ## Solution
> > 
> > Among many choices, `dir()` lists the `median()` function as a possibility.  Thus,
> > 
> > ```python
> > data.median()
> > ```
> {: .solution}
{: .challenge}


[pandas-dataframe]: https://pandas.pydata.org/pandas-docs/stable/generated/pandas.DataFrame.html
[pandas-series]: https://pandas.pydata.org/pandas-docs/stable/generated/pandas.Series.html
[numpy]: https://www.numpy.org/
