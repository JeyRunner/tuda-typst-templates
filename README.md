# Typst Template for the Corporate Design of TU Darmstadt [WIP]
This template can be used to write in [Typst](https://github.com/typst/typst) with the corporate design of [TU Darmstadt]().


## Implemented Templates
The templates imitate the style of the corresponding latex templates in [tuda_latex_templates](https://github.com/tudace/tuda_latex_templates).
Note that there can be visual differences between the original latex template and the typst template (you may open an issue when you find one).

| Template  | Preview | Scope |
----|----|--|
|[tudapub](templates/tudapub/tudapub.typ) | <img src="img/tudapub_prev.png" height="300px"> | Master and Bachelor thesis |


## Usage
Create a folder for your writing project and download this template into the `templates` folder:
```bash
mkdir my_thesis && cd my_thesis
mkdir templates && cd templates
git clone https://github.com/JeyRunner/tuda-typst-templates templates/
```
Download the tud logo from [download.hrz.tu-darmstadt.de/protected/ULB/tuda_logo.pdf](https://download.hrz.tu-darmstadt.de/protected/ULB/tuda_logo.pdf) and put it into the `templates/tuda-typst-templates/templates/tudapub/logos` folder.
Now execute the following script in the `logos` folder to convert it into an svg:
```bash
cd templates/tuda-typst-templates/templates/tudapub/logos
./convert_logo.sh
```


Create a simple `main.typ` in the root folder (`my_thesis`) of your new project:
```js
#import " templates/tuda-typst-templates/templates/tudapub/tudapub.typ": tudapub

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
And compile it:
```bash
typst --watch main.typ --font-path templates/tuda-typst-templates/templates/tudapub/fonts
```
This will watch your file and recompile it to a pdf when the file is saved. For writing you can use [Vscode](https://code.visualstudio.com/) with these extension: [Typst LSP](https://marketplace.visualstudio.com/items?itemName=nvarner.typst-lsp) and [Typst Preview](https://marketplace.visualstudio.com/items?itemName=mgt19937.typst-preview).

Note that we add `--font-path` to ensure that the correct fonts are used.
Due to a bug (typst/typst#2917 typst/typst#2098) typst sometimes uses the font `Roboto condensed` instead of `Roboto`.
To on the safe side, double-check the embedded fonts in the pdf (there should be no `Roboto condensed`).
What also works is to uninstall/deactivate all `Roboto condensed` fonts from your system.