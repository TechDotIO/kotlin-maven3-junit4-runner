# kotlin-maven3-junit4-runner
First, this runner compiles the project and generate all jars (project + dependencies).

At each play, it compiles the user's answer using an optmized version of `kotlinc` and run the specified test case using JUnit 4.


# How to Use

To use this runner for your playground, edit the `techio.yml` file and add the following lines to your project:

    runner: techio/kotlin-maven3-junit4-runner:1.0.6-kotlin-1.1.50

## Example

**A Git repository example**

```
.
├── techio.yml
├── markdowns
│   └── <YOUR_LESSONS>.md
└── projects
    └── example                    # Your project root
        ├── pom.xml
        ├── src
        │   └── example.kt         # The stub provided to the user
        └── test
            └── exampleTest.kt     # Your JUnitTest Class
```

**In your kotlin project**

*example.kt*
```kotlin
/**
 * This method should return the sum between a and b
 **/
fun sum(a: Int, b: Int): Int {
    return 1;
}
```

*exampleTest.kt*
```kotlin
import org.junit.Assert;
import org.junit.Test;

class ExampleTest {

	@Test fun testSum() {
		int a = 23487;
		int b = 240587;
		Assert.assertEquals(sum(a, b), a + b);
	}
}
```

**In your lesson**
```md
@[Fix the function sum() to have it return the sum of the two integers passed as arguments]({"stubs": ["src/example.kt"],"command": "ExampleTest#testSum"})
```

**Notes**
1. If your stub does not compile, just put it outside of the source directory, for example in a `stub/` directory at the root of your project.
2. The test is executed in the context of the maven project located at the root of your playground project. If you have separate maven projects and would like to execute a test in the context of one of them you can specify the directory of this project as the first argument of the `command` attribute: `"command": "snippets/subproject ExampleTest#testSum"`
