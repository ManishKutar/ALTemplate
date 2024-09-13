[[_TOC_]]

# Object ID Allocations (in case you have multiple developers working)

| App | Allocated to | Object ID from | Object ID to |
|--|--|--|--|
|  |  |  |  |

# Sample file structure
All `.al` files are placed in the `.src/` folder. Each Object Type should be in its respective subfolder. Subfolders must be named using Pascal Case (sample: `ReportExtensions`).
```
├───.alpackages/
│       ...
│
├───.snapshots/
│       ...
│
├───.src/
│   ├───Codeunits/
│   │       TestWIN.Codeunit.al
│   │
│   ├───PageExtensions/
│   │       UserCardWIN.PageExt.al
│   │
│   ├───Pages/
│   │       SampleWIN.Page.al
│   │
│   ├───TableExtensions/
│   │       UserSetupWIN.TableExt.al
│   │
│   └───Tables/
│           SampleWIN.Table.al
│
├───.vscode/
│   │   extensions.json
│   │   launch.json
│   │   rad.json
│   │   settings.json
│   │
│   └───.alcache/
│           ...
│
├───Translations/
│       BC18 Boilerplate.g.xlf
│
│   .gitignore
│   app.json
│   AppSourceCop.json
│   logo.png
│   Winspire_BC18 Boilerplate_1.0.0.0.app
```
Report Layouts must be placed in `.src/Layouts/`, and follow the respective Report's file name, e.g. `SampleWIN.Report.al` > `SampleWIN.Layout.rdlc`

# Sample app.json
If your extension is created based on the boilerplate, change the following parameters in app.json:
1. id (can be generated in PowerShell using `New-Guid`)
2. name
3. brief
4. description
5. dependencies (if applicable)
6. idRanges
```
{
  "id": "51c8ff90-58ee-4d45-86b2-11f0a18479c7",
  "name": "BC18 Boilerplate",
  "publisher": "Winspire Solutions",
  "version": "1.0.0.0",
  "brief": "Microsoft Dynamics 365 Business Central Boilerplate Project",
  "description": "Microsoft Dynamics 365 Business Central Boilerplate Project",
  "privacyStatement": "https://winspiresolutions.com/",
  "EULA": "https://winspiresolutions.com/",
  "help": "https://winspiresolutions.com/",
  "url": "https://winspiresolutions.com/",
  "logo": "logo.png",
  "dependencies": [],
  "screenshots": [],
  "platform": "18.0.0.0",
  "application": "18.0.0.0",
  "idRanges": [
    {
      "from": 50000,
      "to": 59999
    }
  ],
  "contextSensitiveHelpUrl": "https://winspiresolutions.com/",
  "showMyCode": false,
  "target": "Cloud",
  "runtime": "7.0",
  "features": [
    "TranslationFile",
    "GenerateCaptions"
  ]
}
```

# Recommended Settings (.vscode/settings.json)
Enabling Code Analysis and resolving AL warnings if possible is mandatory. CRS parameters will help to automatically manage file names according to AL Best Practices.
```
{
    "al.enableCodeAnalysis": true,
    "al.codeAnalyzers": [
        //"${AppSourceCop}",
        "${CodeCop}",
        "${UICop}"
    ],
    "CRS.FileNamePattern": "<ObjectNameShort>.<ObjectTypeShortPascalCase>.al",
    "CRS.FileNamePatternExtensions": "<ObjectNameShort>.<ObjectTypeShortPascalCase>.al",
    "CRS.FileNamePatternPageCustomizations": "<ObjectNameShort>.<ObjectTypeShortPascalCase>.al",
    "CRS.RenameWithGit": true,
    "CRS.ObjectNameSuffix": " WIN",
    "CRS.OnSaveAlFileAction": "Rename"
}

```

# Recommended VSCode extensions (.vscode/extensions.json)
```
{
    "recommendations": [
        "eamodio.gitlens",
        "humao.rest-client",
        "ms-dynamics-smb.al",
        "asuka.insertnumbers",
        "gruntfuggly.todo-tree",
        "yzhang.markdown-all-in-one",
        "martonsagi.al-object-designer",
        "waldo.crs-al-language-extension",
        "ms-vsliveshare.vsliveshare-pack",
        "andrzejzwierzchowski.al-code-outline"
    ]
}
```

# Recommended .gitignore
```
## --- AL gitignore ---
## Ignores generated binary files and 
## temporary files from Visual Studio and Visual Studio code

# Binary files
.alpackages/
*.app

# Temp files
.vs/
#.vscode/
.vscode/.alcache/
.vscode/.altemplates/
.vscode/rad.json
.vscode/launch.json

# Others
Translations/
notes.txt
~$*
*~

```

# Pull Requests
## Link Work items
- Linking work item is mandatory:
![image.png](/.attachments/image-16fae60a-ce2a-4693-b389-eda498708ed1.png)
- Resolving all review comments is mandatory after the fix / changes are done:
![image.png](/.attachments/image-248a87e9-68ba-4a4c-b5ea-662bdd9889e7.png)

# Rules for Rejection
## Rules

| Title|Default Severity|AL version|
|---|---|---|
|FlowFields should not be editable.|Warning|
|`Commit()` needs a comment to justify its existence. Either a leading or a trailing comment.|Warning|
|Do not use an Object ID for properties or variable declarations.|Warning|
|`DrillDownPageId` and `LookupPageId` must be filled in table when table is used in list page.|Warning|
|The casing of variable/method usage must align with the definition.|Warning|
|Fields with property `AutoIncrement` cannot be used in temporary table (`TableType = Temporary`).|Error|
|Every table needs to specify a value for the `DataPerCompany` property. Either `true` or `false`.|Disabled|
|Filter operators should not be used in `SetRange`.|Warning|
|Show info message about code metrics for each function or trigger.|Disabled|
|Show warning about code metrics for each function or trigger if either cyclomatic complexity is 8 or greater or maintainability index 20 or lower.|Warning|
|Every object needs to specify a value for the `Access` property. Either `true` or `false`. Optionally this can also be activated for table fields with the setting `enableRule0011ForTableFields`.|Disabled|
|Using hardcoded IDs in functions like `Codeunit.Run()` is not allowed.|Warning|
|Any table with a single field in the PK of type code or text, should have set `NotBlank` on the PK field.|Warning|
|The Caption of permissionset objects should not exceed the maximum length.|Warning|
|All application objects should be covered by at least one permission set in the extension.|Warning|
|Caption is missing. Optionally this can also be activated for fields on API objects with the setting `enableRule0016ForApiObjects`.|Warning|
|Writing to a FlowField is not common. Add a comment to explain this.|Warning|
|Events in internal codeunits are not accessible to extensions and should therefore be avoided.|Info|
|If Data Classification is set on the Table. Fields do not need the same classification.|Info|
|If Application Area is set on the TablePage. Controls do not need the same classification.|Info|
|`Confirm()` must be implemented through the `Confirm Management` codeunit from the System Application.|Info|
|`GlobalLanguage()` must be implemented through the `Translation Helper` codeunit from the Base Application.|Info|
|Always provide fieldsgroups `DropDown` and `Brick` on tables.|Info|
|Procedure or Trigger declaration should not end with semicolon.|Info|
|Procedure must be either local, internal or define a documentation comment.|Info|
|ToolTip must end with a dot.|Info|
|Utilize the `Page Management` codeunit for launching page.|Info|
|Event subscriber arguments now use identifier syntax instead of string literals.|Info|
|Use `CompareDateTime` method in `Type Helper` codeunit for DateTime variable comparisons.|Info|
|Set Access property to Internal for Install/Upgrade codeunits.|Info|
|Set ReadIsolation property instead of LockTable method.|Info|
|Clear(All) does not affect or change values for global variables in single instance codeunits.|Warning|
|The specified runtime version in app.json is falling behind.|Info|
|The property `Extensible` should be explicitly set for public objects.|Disabled|
|Explicitly set `AllowInCustomizations` for fields omitted on pages.|Info|12.1|
|ToolTip must start with the verb "Specifies".|Info|
|Do not use line breaks in ToolTip.|Info|
|Try to not exceed 200 characters (including spaces).|Info|
|The given argument has a different type from the one expected.|Warning|
|Explicitly set the `RunTrigger` parameter on build-in methods.|Info|
|Empty Captions should be `Locked`.|Info|
|`AutoCalcFields` should only be used for FlowFields or Blob fields.|Warning|
|Use `SecretText` type to protect credentials and sensitive textual values from being revealed.|Info|14.0|
|Tables coupled with `TransferFields` must have matching fields.|Warning|
|Zero (0) `Enum` value should be reserved for Empty Value.|Info|
|`Label` with suffix Tok must be locked.|Info|
|Locked `Label` must have a suffix Tok.|None|
|Use Error with a `ErrorInfo` or `Label` variable to improve telemetry details.|Info|
|`SourceTable` property not defined on Page.|Info|
|`SetFilter` with unsupported operator in filter expression.|Info|
|Do not assign a text to a target with smaller size.|Warning|12.1|
|The internal procedure is declared but never used.|Info|
|The internal procedure is only used in the object in which it is declared. Consider making the procedure local.|Info|
|The suffix `Tok` is meant to be used when the value of the label matches the name.|Info|
|Empty Enum values should not have a specified `Caption` property.|Info|
|Enum values must have non-empty a `Caption` to be selectable in the client|Info|
