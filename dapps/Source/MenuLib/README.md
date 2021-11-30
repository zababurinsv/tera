## Tabbed menu library


---

### Description
- Allows you to create a menu in the form of tabs using the tags: **menu**, **item**
- The content is set by the tag: **content** (link to the menu item via the data-ref attribute)
- If you set **id** on the menu item, you can navigate through the history.


### RUS:
- Позволяет создавать меню в виде вкладок через теги: **menu**, **item**
- Контент задается тегом: **content** (связь с элементом меню через атрибут data-ref)
- Если задан идентификатор **id** на элементе меню то возможна навигация по истории.


### Use

#### Main network:
```html
<head>
<link type="text/css" rel="stylesheet" href="/file/70172057/0"/>
<script src="/file/70172078/0"></script>
</head>
```


#### Test network
```html
<head>
<link type="text/css" rel="stylesheet" href="/file/6708112/0"/>
<script src="/file/6708104/0"></script>
</head>

```



### Example:
```html

<!--include css and sripts--->


<menu>
    <item data-ref="m1" id="idPage1">
        Menu-1
    </item>

    <item data-ref="m2" id="idPage2">
        Menu-2
    </item>

    <item data-ref="m3" id="idPage3">
        Menu-3
    </item>
</menu>


<content data-ref="m1">
    =Content menu1=
</content>

<content data-ref="m2">

    =Content menu2=

    <BR>
    <menu>
        <item data-ref="s1">
            Sub 1
        </item>
        <item data-ref="s2">
            Sub 2
        </item>
        <item data-ref="s3">
            Sub 3
        </item>
    </menu>

    <content data-ref="s1">
        =Content sub-menu1=
    </content>

    <content data-ref="s2">
        =Content sub-menu2=
    </content>

</content>

```