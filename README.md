# StlParser

This program parses STL files and returns the following tuple:
```elixir
{:ok, %{number_of_triangles: number_of_triangles, surface_area: surface_area, solid: solid}}
```


The code challenge instructions can be found here: [problem source](https://gist.github.com/fast-radius-circleci/2526a133f1e3be4174f92a602c9bddd3)

## Installation

After downloading repo be sure to run the following before testing:
```bash
$ mix deps.get
```
Please check .tools-versions for the expected Elixir and Erlang versions. This project supports asdf for Elixir/Erlang versioning.

## Assumptions
* There is one solid definition per file
* Each facet will always be a triangle (with 3 vertices)
* The sample files are representative of all possible stl files (this is likely a wrong assumption)

## Running the Code
I didn't write a command line or web interface for this solution, but I tested the module using ExUnit. The main test module is StlParserTest, which tests both the simple and mood stl examples. To test the solution run the following at the command line:
```bash
$ mix test
```
To verify test coverage, execute the following:
```bash
$ mix coveralls
```
To run the linter, execute the following:
```bash
$ mix credo
```
## Design Decisions
I have never worked with 3D graphics before and my math skills are a bit rusty. This was a fun problem.

For starters, I set up the overall expected behavior in StlParserTest. That served as my overall acceptance tests. Future acceptance tests would be placed in that test nodule.

I next created the SolidReader, which reads the contents of a STL file and returns a struct representation of the data. After returning the solid instance, I create the return data using the facets list for a total count, and I provided a reduce function calculate all the facet polygons and sum up the results.

## Possible optimizations
* I could eliminate the Solid struct altogether if the only data that this will need to provide in the future are number_of_triangles and surface_area. I could accumulate the area as I read through the file.
* Calculation of areas could be parallelized.
