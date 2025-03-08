# Typst Templates for the Corporate Design of TU Darmstadt :book:
These **unofficial** templates enable you to write documents in [Typst](https://github.com/typst/typst) with the corporate design of [TU Darmstadt](https://www.tu-darmstadt.de/).

#### Disclaimer
Please ask your supervisor if you are allowed to use Typst and one of these templates for your thesis or other documents.
Note that this template is not checked by TU Darmstadt for correctness.
Thus, this template does not guarantee completeness or correctness.
For notes for publishing on TUbama see the [Publishing](#publishing-on-tubama).


## Implemented Templates
The templates imitate the style of the corresponding latex templates in [tuda_latex_templates](https://github.com/tudace/tuda_latex_templates).
Note that there can be visual differences between the original latex template and the Typst template (you may open an issue when you find one).

For missing features, ideas or other problems you can just open an issue :wink:. Contributions are also welcome.

| Template | Preview | Example | Scope |
|----------|---------|---------|-------|
| [tudapub](templates/tudapub/template/tudapub.typ) | <img src="templates/tudapub/preview/tudapub_prev-01.png" height="300px"> | [example_tudapub.pdf](example_tudapub.pdf) <br/> [example_tudapub.typ](example_tudapub.typ) | Master and Bachelor thesis |
| [tudaexercise](templates/tudaexercise/template/tudaexercise.typ) | <img src="templates/tudaexercise/preview/tudaexercise_prev-1.png" height="300px"> | [Example File](templates_examples/tudaexercise/main.typ) | Exercises |

## Usage
Create a new typst project based on this template locally.
```bash
# for tudapub
typst init @preview/athena-tu-darmstadt-thesis
cd athena-tu-darmstadt-thesis

# for tudaexercise
typst init @preview/athena-tu-darmstadt-exercise
cd athena-tu-darmstadt-exercise
```
Or create a project on the typst web app based on this template.

<details>
<summary>Or do a manual installation of this template.</summary>
For a manual setup create a folder for your writing project and download this template into the `templates` folder:

```bash
mkdir my_thesis && cd my_thesis
mkdir templates && cd templates
git clone https://github.com/JeyRunner/tuda-typst-templates
```
</details>

### Logo and Font Setup
Download the tud logo from [download.hrz.tu-darmstadt.de/protected/ULB/tuda_logo.pdf](https://download.hrz.tu-darmstadt.de/protected/ULB/tuda_logo.pdf) and put it into the `asssets/logos` folder.
Now execute the following script in the `asssets/logos` folder to convert it into an svg:

```bash
cd asssets/logos
./convert_logo.sh
```

Note: The here used `pdf2svg` command might not be available. In this case we recommend a online converter like [PDF24 Tools](https://tools.pdf24.org/en/pdf-to-svg). There also is a [tool](https://github.com/FussballAndy/typst-img-to-local) to install images as local typst packages.

Also download the required fonts `Roboto` and `XCharter`:
```bash
cd asssets/fonts
./download_fonts.sh
```
Optionally you can install all fonts in the folders in `fonts` on your system. But you can also use Typst's `--font-path` option. Or install them in a folder and add the folder to `TYPST_FONT_PATHS` for a single font folder.

Note: wget might not be available. In this case either download it or replace the command with something like `curl <url> -o <filename> -L`

<details>
<summary>Create a main.typ file for the manual template installation.</summary>
Create a simple `main.typ` in the root folder (`my_thesis`) of your new project:

```js
#import "templates/tuda-typst-templates/templates/tudapub/template/lib.typ": *

#show: tudapub.with(
  title: [
    My Thesis
  ],
  author: "My Name",
  accentcolor: "3d"
)

= My First Chapter
Some Text
```

</details>

### Compile you typst file

```bash
typst --watch main.typ --font-path asssets/fonts/
```

This will watch your file and recompile it to a pdf when the file is saved. For writing, you can use [Vscode](https://code.visualstudio.com/) with these extensions: [Tinymist Typst](https://marketplace.visualstudio.com/items?itemName=myriad-dreamin.tinymist). Or use the [typst web app](https://typst.app/) (here you need to upload the logo and the fonts).

Note that we add `--font-path` to ensure that the correct fonts are used.
Due to a bug (typst/typst#2917 typst/typst#2098) typst sometimes uses the font `Roboto condensed` instead of `Roboto`.
To be on the safe side, double-check the embedded fonts in the pdf (there should be no `Roboto condensed`).
What also works is to uninstall/deactivate all `Roboto condensed` fonts from your system.

### Publishing on TUbama
For publishing your compiled document (e.g. thesis) on TUbama, the document has to comply with the pdf/A standard. 
Therefore, set the PDF standard for compiling for the final submission:
```bash
typst compile main.typ --font-path asssets/fonts/ --pdf-standard a-2b
```
In case this should not yield a PDF which is accepted by TUbama, you can use a converter to convert from the Typst output to PDF/A, but check that there are no losses during the conversion. 

## Todos
- [todos of thesis template](templates/tudapub/TODO.md)

## Dev Notes
### Publish Locally
For creating a local package you need to use the `scripts/publish.py` script.
```python
python ./scripts/publish.py --local
```
