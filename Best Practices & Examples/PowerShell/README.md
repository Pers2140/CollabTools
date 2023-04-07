# Best Practices for Writing PowerShell Functions

### 1. Use descriptive and meaningful function names. <--- Use Get-Verb for approved commands

</br>

```powershell

# Good: Verb-Noun naming convention
function Get-ProcessList {
    # Function body
}

# Bad: Non-descriptive name
function MyFunc {
    # Function body
}

```
</br>

### 2. Provide Help Documentation: Include inline help documentation using comments or the Get-Help cmdlet. Describe the purpose of the function, its parameters, and provide examples of usage. For example:

</br>

```powershell

function Get-FileContents {
    param(
        [string]$Path,
        [switch]$IncludeHidden = $false
    )
    <#
    .SYNOPSIS
    Retrieves the contents of a file.

    .DESCRIPTION
    This function reads the contents of a file and returns the content as a string.

    .PARAMETER Path
    Specifies the path of the file to retrieve the contents from.

    .PARAMETER IncludeHidden
    Indicates whether to include hidden files in the search. Default is false.

    .EXAMPLE
    Get-FileContents -Path C:\MyFile.txt
    Retrieves the contents of the file located at C:\MyFile.txt.

    .EXAMPLE
    Get-FileContents -Path C:\MyFile.txt -IncludeHidden
    Retrieves the contents of the hidden file located at C:\MyFile.txt.
    #>
    # Function body
}
```

### 3. Use Pipeline Support: Utilize the power of PowerShell pipelines by designing your functions to accept input from the pipeline and output results to the pipeline

</br>

### 4. Keep Functions Small and Modular: Follow the principle of Single Responsibility Principle (SRP) and keep your functions small and focused on a single task. This makes your functions more reusable and easier to maintain

</br>

### 5. Use Proper Error Handling: Include error handling in your functions to gracefully handle exceptions and provide informative error messages. Use try-catch blocks to catch and handle errors

</br>

```powershell

function Get-FileContents {
    param(
        [string]$Path,
        [switch]$IncludeHidden = $false
    )
    try {
        # Function body
    }
    catch {
        Write-Error "Failed to retrieve file contents. $_"
    }
}

```

6. Avoid using global variables.

7. Test your functions.

8. Follow security best practices.

9. Keep your functions versioned.

## This template includes the following elements:

- Function definition: Starts with the `function` keyword followed by the function name, followed by the function logic enclosed in curly braces `{}`.
- `[CmdletBinding()]`: This attribute enables advanced function features like parameter validation, pipeline input, and more.
- `param`: Defines the function parameters with their names, types, and optional attributes.
- Function logic: Contains the code that executes the function's purpose, which can include data manipulation, error handling, and other logic.
- `try` and `catch`: Optional error handling using a `try` block to handle exceptions that may occur within the function.
- Output: Shows an example of how to write output from the function using the `Write-Output` cmdlet.

### You can customize this boilerplate code by updating the function name, parameters, and logic to suit your specific requirements. You can also add additional parameters, logic, and output as needed for your specific function.
