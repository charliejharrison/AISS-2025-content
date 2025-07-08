---
title: "Data Exploration"
teaching: 50
exercises: 10
---

<!--
This episode contains material modified from the Software Carpentry Lesson Plotting and Programming in Python
Material used is taken from Episodes 7 and 8:
 - https://swcarpentry.github.io/python-novice-gapminder/instructor/07-reading-tabular.html
 - https://swcarpentry.github.io/python-novice-gapminder/instructor/08-data-frames.html
-->


``` r
library(reticulate)
use_condaenv("AISS-2025")
```

``` error
Error in use_condaenv("AISS-2025"): Unable to locate conda environment 'AISS-2025'.
```

:::::::::::::::::::::::::::::::::::::: questions 

- What is Pandas and why should I use it?
- What are some of the ways I can access and explore data?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- Import the Pandas library
- Use Pandas to load a simple CSV data set
- Get some basic information about a Pandas DataFrame
- Know the difference between Pandas Series and DataFrames
- Use label- and position-based indexing with `loc` and `iloc`
- Calculate summary statistics and plot distributions of variables to get a sense of what your data contains

::::::::::::::::::::::::::::::::::::::::::::::::

First things first! Let's import `pandas`. 


``` python
import pandas as pd
```

``` output
ModuleNotFoundError: No module named 'pandas'
```

This gives us access to all the useful code in the `pandas` library. That's about 1500 files and 400,000 lines of Python, plus some high-performance bits written in Cython and C - so we just saved ourselves a lot of work. 

- [Pandas](https://pandas.pydata.org/) is a widely-used Python library for statistics, particularly on tabular data.
- Pandas borrows many features from R's dataframes.
  - A 2-dimensional table whose columns have names and potentially contain different data types
- Load Pandas with `import pandas as pd`. The alias `pd` is commonly used to refer to the Pandas library in code

## Data types in `pandas`

On top of all the usual Python object types (like `str`, `int` and `float`), `pandas` has two main types of its own: `Series` and `DataFrame`. These are both containers for labelled data.

A `Series` is a 1-dimensional container, like a list, but with some extra functionality. 

![A Series is a 1-D labelled array](./fig/01_table_series.svg){alt='A diagram of Series as a 1-D labelled array'}

A `DataFrame` is essentially a collection of `Series`. You can think of a `DataFrame` as a table (like in Microsoft Excel or a SQL database), with `Series` for columns. 

![A DataFrame is a 2-D labelled array](./fig/01_table_dataframe.svg){alt='A diagram of a DataFrame as a 2-D labelled array'}

::: callout

## Pandas has two main objects
 
- A `Series` contains 1-dimensional, labelled data - like a vector, or a column
- A `DataFrame` contains 2-dimensional, labelled data - like a matrix, or a table

::::::

Most of the time you'll be probably interacting with `DataFrame`s. However, many of same principles apply to both `Series` and `DataFrame`s, and the concepts are easier to understand when we're just looking at a single dimension, so we'll learn a bit about `Series` to start with. 

## Key concepts for a `Series`

We can create a `Series` from a `list`, a `range`, or a `dict`:


``` python
integers = pd.Series([0, 1, 2, 3, 4])
```

``` output
NameError: name 'pd' is not defined
```

``` python
evens = pd.Series(range(0, 10, 2)) # range(start, stop, step) 
```

``` output
NameError: name 'pd' is not defined
```

``` python
ordinals = pd.Series({1: 'first', 2: 'second', 3: 'third', 4: 'fourth'})
```

``` output
NameError: name 'pd' is not defined
```

``` python
print(f"integers (from list):\n{integers}\n")
```

``` output
NameError: name 'integers' is not defined
```

``` python
print(f"evens (from range):\n{evens}\n")
```

``` output
NameError: name 'evens' is not defined
```

``` python
print(f"ordinals (from dict):\n{ordinals}\n")
```

``` output
NameError: name 'ordinals' is not defined
```

There are a few things to notice here. We'll go through the important points.

### Access data by its label using `loc[]`

Each of the `Series` has a set of labels, shown on the left in the output above. This is the index. Data elements can be accessed via these labels, using the function `Series.loc`:


``` python
print(integers.loc[2])
```

``` output
NameError: name 'integers' is not defined
```

``` python
print(evens.loc[2])
```

``` output
NameError: name 'evens' is not defined
```

``` python
print(ordinals.loc[2])
```

``` output
NameError: name 'ordinals' is not defined
```

::: callout

Use the `loc` to access data using its label. It takes values in square brackets `[]`

::::::

For `integers` and `evens`, we just passed in a sequence of values and `pandas` automatically created an index, using numbers starting from zero. To create `ordinals`, we passed in a `dict`, which already includes labels. `pandas` used these labels to create the index. Note that in our case, the labels are all integers, but they don't have to be - for example, they could be strings, or dates. 

::: callout 

Indexes contain the labels for data. They are often sequences of integers, but they don't have to be.

::::::

### Access data by its position using `iloc[]`

Sometimes we might want to access data in a specific _position_, rather than by using its index label. `pandas` provides another function for this, called `iloc`:


``` python
print(integers.iloc[0])
```

``` output
NameError: name 'integers' is not defined
```

``` python
print(evens.iloc[0])
```

``` output
NameError: name 'evens' is not defined
```

``` python
print(ordinals.iloc[0])
```

``` output
NameError: name 'ordinals' is not defined
```

::: callout

Use the `iloc` function to access data using its position. Like `loc`, it takes values in square brackets `[]`

Note that `iloc` is "0-indexed" - the first element is number 0, the `i`th element is number `i-1`.

::::::

OK that's all cool, but not very useful. What if we want to get more than one value at a time? We can use `loc` and `iloc` for that too. 

### Get multiple values by passing a list to `loc[]`

If we give `loc` a list of labels, we'll get back just the values indexed by those labels:


``` python
evens.loc[[1, 3]]
```

``` output
NameError: name 'evens' is not defined
```

### Get a slice of data with a colon `:`

With `iloc` we can specify a range of values using a colon `:`. This is called a slice:


``` python
ordinals.iloc[1:3]
```

``` output
NameError: name 'ordinals' is not defined
```


Note that the slice contains everything up to but **not including** the second position provided. 

::: callout 

Slicing a `Series` using `iloc[start:stop]` returns a range of values at the positions `start` to `stop-1`. 

::::::

If we omit a value on either side of the colon, the range will extend to the end of the `Series` - so `[:2]` is equivalent to `[0:2]`, and `[1:]` gives you all except the first element.

:::::: challenge

Can you guess what happens when you call `iloc[:]` with no numbers? 

::: solution

You get the whole `Series`


``` python
print(ordinals.iloc[:])
```

``` output
NameError: name 'ordinals' is not defined
```

``` python
print(ordinals.iloc[:].equals(ordinals))
```

``` output
NameError: name 'ordinals' is not defined
```
:::

::::::::

::: callout

Now for something a bit confusing. You can also use a slice on `loc` to get a range of values between two _index labels_, but there's a crucial difference: when slicing with `loc`, both the start bound AND the stop bound are included, if present in the index. 


``` python
ordinals.iloc[1:3]
```

``` output
NameError: name 'ordinals' is not defined
```

``` python
ordinals.loc[1:3]
```

``` output
NameError: name 'ordinals' is not defined
```
The `loc` function access elements by label. Integers are valid labels, but they refer to the label and **not the position**.

::::::

### Filter data on conditions using boolean indexing

You can also use `loc` to select only a subset of data that meets specific criteria, using a technique called boolean indexing. To get the integers that are greater than 2, we can use:


``` python
integers.loc[integers > 2]
```

``` output
NameError: name 'integers' is not defined
```

What's happening here? The `>` operator compares each element of `integers` to 2, and returns `True` or `False` for each one. This creates a `Series` of booleans:


``` python
evens > 2
```

``` output
NameError: name 'evens' is not defined
```

We're then passing this `Series` into `loc` and using it to tell Pandas whether or not we want each value. 

There are lots of operators and functions that can be used to return boolean values. Some common ones are 

- `<`: "less than"
- `>`: "greater than"
- `==`: "equal to" (note the double equals symbol!)
- `<=`: "less than or equal to"
- `>=`: "greater than or equal to"
- `!=`: "not equal to"

You can combine criteria using logical operators with the symbols `|` for "or", `&` for "and", and `~` for "not". For example, we can get even numbers that are greater than 3 and less than 8 using:


``` python
evens.loc[(evens > 3) & (evens < 8)]
```

``` output
NameError: name 'evens' is not defined
```

We'll go into this in more depth later.

### A `Series` has a single data type

Each of the `Series` has a data type. When we print a `Series`, the data type (`dtype`) is shown beneath the contents. `integers` and `evens` both have the dtype `int64`. This is simple enough, they both contains integers. However, `ordinals`, whose data elements are strings, shows `dtype: object`. Why is this? 

The `object` type is like a generic catch-all. It was used before Pandas was able to support strings, and it remains in situations like this because the developers didn't want to break things. There are some good reasons for telling Pandas to treat our data as strings instead. We can specify the data type when we create the `Series`, like this:


``` python
str_ordinals = pd.Series({1: 'first', 2: 'second', 3: 'third', 4: 'fourth'}, dtype="string")
```

``` output
NameError: name 'pd' is not defined
```

``` python
print(str_ordinals)
```

``` output
NameError: name 'str_ordinals' is not defined
```

Or we can create a new `Series` from the old one and convert the type, like this:


``` python
str_ordinals = ordinals.astype("string")
```

``` output
NameError: name 'ordinals' is not defined
```

Pandas will do its best to "cast" every element in the series as whatever type we specify.

::: callout 

`Series` are intended to store data of a single type. This means that in general, a `Series` should contain only, for example, text or numbers - not both. 

We can specify the data type of a `Series` when we create it.

::::::

## Dataframes

A `DataFrame` has rows and columns. Like a `Series`, it has labels, but now both the rows and the columns have labels. Let's combine our `Series` into a single `DataFrame`:


``` python
numbers = pd.DataFrame({'integers': integers, 'evens': evens, 'ordinals': str_ordinals})
```

``` output
NameError: name 'pd' is not defined
```

``` python
print(numbers)
```

``` output
NameError: name 'numbers' is not defined
```

We can easily join these Series together, because they share a lot of index labels. Pandas does a pretty good job of lining up the data, and each of our `Series` is now a column in `numbers`. We used a dict to pass in column labels. Note that the data types are not printed. 

The `Series` are merged on their index. Because the `Series` have a lot of index labels in common, this works pretty well for us. However, `ordinals` has only 4 values instead of 5, and it only starts at 1 - there's no common way of spelling "0th" ("zeroth"? "zeroeth"? "zeroast"?). This means that when the indexes are merged, the `ordinals` column has a missing value.

::: callout

Missing values are represented as `<NA>`

::::::

### Get rows from a `DataFrame` using `loc[row_label]`

Now when we use the `loc` function with a single value, we get back a whole row:


``` python
print(numbers.loc[1])
```

``` output
NameError: name 'numbers' is not defined
```

The output here is a `Series` containing all the data from the row at index value 1. The index labels for this new `Series` correspond to the column labels from the `DataFrame`. The row has a `dtype`, which is object, because we have a mix of strings and numbers. 

If we pass a list of values, we'll get back a `DataFrame` containing multiple rows:


``` python
numbers.loc[[1, 3]]
```

``` output
NameError: name 'numbers' is not defined
```

If we take a slice of a `DataFrame` (using a colon `:` like before), we'll get back another DataFrame:


``` python
numbers[1:3]
```

``` output
NameError: name 'numbers' is not defined
```

In these examples we're specifying the row, and Pandas assumes that we want every column. What if we don't?

### Specify columns in a `DataFrame` using `loc[row_label, column_label]`

If we want to access a single element in the `DataFrame`, we need to pass two labels to `loc`: one for the row, and one for the column. In our example `DataFrame` the rows are indexed with numbers, but the columns are indexed with strings, so we need to use, for example:


``` python
numbers.loc[2, 'evens']
```

``` output
NameError: name 'numbers' is not defined
```

::: callout

The index order in a `DataFrame` is `[row, column]`

::::::

What if we want to access a whole column? If you solved the challenge above, you'll remember that a slice with no endpoints returns the whole `Series`. We can use this like so:


``` python
numbers.loc[:, 'integers']
```

``` output
NameError: name 'numbers' is not defined
```

:::::: challenge

Can you pull out just the integers 1, 2, and 3 and their corresponding ordinals? 

::: hint

Remember that slicing with `loc` includes both the start and stop position in an index. 

::::::

::: solution


``` python
numbers.loc[1:3, ['integers', 'ordinals']]
```

``` output
NameError: name 'numbers' is not defined
```
::::::

::::::::

### Remove rows with missing values with `dropna()`

We need to decide how to treat missing values. In a perfect world all our data would be clean and tidy, but the cruel reality is that it's often quite messy. Thus the function `DataFrame.dropna()` is much more useful than I'd like it to be! 

:::::: challenge

Use `help(numbers.dropna)` or the Shift+Tab shortcut to view the documentation for the `dropna()`. Then use it to create two new `Dataframes`: one without the row containing the missing value, and one without the column.

::: solution


``` python
numbers_clean_rows = numbers.dropna()
```

``` output
NameError: name 'numbers' is not defined
```

``` python
numbers_clean_cols = numbers.dropna(axis='columns')
```

``` output
NameError: name 'numbers' is not defined
```
If you used your past knowledge from working with numpy arrays you might have tried


``` python
numbers_clean_cols = numbers.dropna(axis=1)
```

``` output
NameError: name 'numbers' is not defined
```

These two are equivalent. Pandas provides the names as an alternative that might be easier to remember.

::::::

::::::::

## Use the Pandas library to do statistics on tabular data.

Read a Comma Separated Values (CSV) data file with `pd.read_csv()`.
  - The first argument is the name of the file to be read
  - Returns a dataframe that you can assign to a variable
  

``` python
import pandas as pd
```

``` output
ModuleNotFoundError: No module named 'pandas'
```

``` python
data_oceania = pd.read_csv('data/gapminder_gdp_oceania.csv')
```

``` output
NameError: name 'pd' is not defined
```

``` python
print(data_oceania)
```

``` output
NameError: name 'data_oceania' is not defined
```

- The columns in a Dataframe are the observed variables, and the rows are the observations.
- Pandas uses backslash `\` to show wrapped lines when output is too wide to fit the screen. If you're using an IDE like Jupyter Labs it might display more nicely
- Using descriptive Dataframe names helps us distinguish between multiple Dataframes so we won't accidentally overwrite a Dataframe or read from the wrong one.

:::::::::::::::::::::::::::::::::::::::::  callout

## File Not Found

The code above assumes your data file is in a `data` sub-directory in the same place as your code, which is why the path to the file is `data/gapminder_gdp_oceania.csv`. If the data directory is a level above, you'll need to use `../data/gapminder_gdp_oceania.csv`. 

If you get the path wrong, you will get a runtime error that ends with a line like this:

```error
FileNotFoundError: [Errno 2] No such file or directory: 'data/gapminder_gdp_oceania.csv'
```

If you see this, double check the path, look for typos, and be aware of directory nesting. 

::::::::::::::::::::::::::::::::::::::::::::::::::

## Use `index_col` to specify that a column's values should be used as row headings.

- Row headings are numbers (0 and 1 in this case - we only have two rows), but really we want to index by country.
- We can pass the name of the column we want to use as an index to `read_csv`, using its `index_col` parameter.
- Remember to give this new object a useful name. For example, `data_oceania_country` tells us which region the data includes (`oceania`) and how it is indexed (`country`).


``` python
data_oceania_country = pd.read_csv('data/gapminder_gdp_oceania.csv', index_col='country')
```

``` output
NameError: name 'pd' is not defined
```

``` python
print(data_oceania_country)
```

``` output
NameError: name 'data_oceania_country' is not defined
```

## Use the `DataFrame.info()` method to find out more about a dataframe.


``` python
data_oceania_country.info()
```

``` output
NameError: name 'data_oceania_country' is not defined
```

- This is a `DataFrame`
- It has two rows named `'Australia'` and `'New Zealand'`
- It has twelve columns, each of which has two 64-bit floating point values.
  - We will talk later about null values, which are used to represent missing observations.
- Uses 208 bytes of memory.

## The `DataFrame.columns` variable stores information about the dataframe's columns.

- Note that this is data, *not* a method.  (It doesn't have parentheses.)
  - Like `math.pi`.
  - So do not use `()` to try to call it.
- This is called a *member variable*, or just *member*.


``` python
print(data_oceania_country.columns)
```

``` output
NameError: name 'data_oceania_country' is not defined
```

## Use `DataFrame.T` to transpose a dataframe.

- Sometimes want to treat columns as rows and vice versa.
- Transpose (written `.T`) doesn't copy the data, just changes the program's view of it.
- Like `columns`, it is a member variable.


``` python
print(data_oceania_country.T)
```

``` output
NameError: name 'data_oceania_country' is not defined
```

## Use `DataFrame.describe()` to get summary statistics about data.

`DataFrame.describe()` gets the summary statistics of only the columns that have numerical data.
All other columns are ignored, unless you use the argument `include='all'`.


``` python
print(data_oceania_country.describe())
```

``` output
NameError: name 'data_oceania_country' is not defined
```

This is not particularly useful with just two records, but very helpful when there are thousands!

:::::: challenge

How would you get the summary statistics by country, instead of by year?

::: solution
First take the transpose with `T`, then use `describe()`:


``` python
data_oceania_country.T.describe()
```

``` output
NameError: name 'data_oceania_country' is not defined
```
::::::

::::::::

:::::: challenge

## Inspecting data

Read the data in a different file, `gapminder_gdp_americas.csv` (which should be in the same directory as `gapminder_gdp_oceania.csv`) into a variable called `data_americas` and display its summary statistics.

::: solution

To read in a CSV, we use `pd.read_csv` and pass the filename `'data/gapminder_gdp_americas.csv'` to it.
We also once again pass the column name `'country'` to the parameter `index_col` in order to index by country.
The summary statistics can be displayed with the `DataFrame.describe()` method.


``` python
data_americas = pd.read_csv('data/gapminder_gdp_americas.csv', index_col='country')
```

``` output
NameError: name 'pd' is not defined
```

``` python
data_americas.describe()
```

``` output
NameError: name 'data_americas' is not defined
```

::::::

::::::::

:::::: challenge

Try out the functions `DataFrame.head()` and `DataFrame.tail()`. What do they do? 

::: hint

You can view the documentation about a function by using `help(data_americas.head)`, or in Jupyters by typing out the function and pressing Shift+Tab.

::::::

::: solution

The function `data_americas.head()` prints the first few rows of the DataFrame. We can specify the number of rows we wish to see with the parameter `n` in our call to `data_americas.head()`. To view the first three rows, execute:


``` python
data_americas.head(n=3)
```

``` output
NameError: name 'data_americas' is not defined
```

Similarly, `data_americas.tail()` prints the last few rows.

::::::

::::::::

:::::: challenge

How would you print the last three *columns*?

::: hint

Remember that you can switch the orientation of a Dataframe...

::::::

::: solution

We need to flip the DataFrame using `T`, then use `tail()`. If you think you might use this a few times, and the data isn't too large, then it's a good idea to create a new DataFrame in which rows and columns are switched:
  

``` python
americas_transpose = data_americas.T
```

``` output
NameError: name 'data_americas' is not defined
```

``` python
americas_transpose.tail(n=3)
```

``` output
NameError: name 'americas_transpose' is not defined
```

::::::

::::::::


::::::::::::::::::::::::::::::::::::: keypoints 

- `pandas` provides two main data structures: Series and DataFrames
- A `Series` is a one-dimensional array-like object
- A `DataFrame` is a two-dimensional array-like object
- Data in a `Series` or `DataFrame` is labelled. The labels are are stored in an index
- Data can be accesssed via its label using `loc`, or via its position using `iloc`
- Use boolean indexing (or "masking") with `loc` for more complicated conditions
- Missing values are represented by `<NA>`
- `DataFrame` indexing goes `[row, column]`
- Take a slice of data using a colon `:`
- Use the Pandas library to get basic statistics out of tabular data.
- Use `index_col` to specify that a column's values should be used as row headings.
- Use `DataFrame.info` to find out more about a dataframe.
- The `DataFrame.columns` variable stores information about the dataframe's columns.
- Use `DataFrame.T` to transpose a dataframe.
- Use `DataFrame.describe` to get summary statistics about data.

::::::::::::::::::::::::::::::::::::::::::::::::
