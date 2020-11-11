/*
 * @project: TERA
 * @version: Development (beta)
 * @license: MIT (not for evil)
 * @copyright: Yuriy Ivanov (Vtools) 2017-2020 [progr76@gmail.com]
 * Web: https://terafoundation.org
 * Twitter: https://twitter.com/terafoundation
 * Telegram:  https://t.me/terafoundation
*/

function toggleTab()
{
    tabs = document.querySelectorAll(".tab");
    tabContents = document.querySelectorAll(".tab-content");
    console.log(tabs);
    for(let i = 0; i < tabs.length; i++)
    {
        tabs[i].addEventListener("click", function ()
        {
            for(let i = 0; i < tabs.length; i++)
            {
                tabs[i].classList.remove("active");
                tabContents[i].classList.remove("active");
            }
            tabs[i].classList.add("active");
            tabContents[i].classList.add("active");
        });
    }
}
function toggleModal(modalWindow,openButton,closeButton)
{
    const openBtn = document.getElementById(openButton);
    const modal = document.querySelector(modalWindow);
    if(modal)
    {
        const closeBtn = modal.querySelector(closeButton);
        const cancel = modal.querySelector(".cancel");
        openBtn.addEventListener("click", function (e)
        {
            e.preventDefault();
            modal.style.display = "flex";
            document.body.style.overflow = "hidden";
        });
        closeBtn.addEventListener("click", function ()
        {
            modal.style.display = "none";
            document.body.style.overflow = "";
        });
        if(cancel)
        {
            cancel.addEventListener("click", function ()
            {
                closeBtn.click();
            });
        }
        modal.addEventListener("click", function (e)
        {
            if(e.target === modal)
            {
                closeBtn.click();
            }
        });
    }
}
let select = function ()
{
    let selectHeader = document.querySelectorAll(".select__header");
    let selectItem = document.querySelectorAll(".select__item");
    selectHeader.forEach(function (item)
    {
        item.addEventListener("click", selectToggle);
    });
    selectItem.forEach(function (item)
    {
        item.addEventListener("click", selectChoose);
    });
    function selectToggle()
    {
        this.parentElement.classList.toggle("is-active");
    };
    function selectChoose()
    {
        let text = this.innerText, select = this.closest(".select"), currentText = select.querySelector(".select__current");
        currentText.innerText = text;
        select.classList.remove("is-active");
    };
}
function dropdownToggle()
{
    const drop = document.querySelectorAll(".dropdown__item");
    drop.forEach(function (item)
    {
        item.addEventListener("click", function (event)
        {
            event.preventDefault();
            let target = event.target;
            for(i = 0; i < drop.length; i++)
            {
                if(drop[i] != item)
                {
                    drop[i].classList.remove("active");
                }
            }
            if(target.classList.contains("drop"))
            {
                item.classList.toggle("active");
            }
        });
    });
}
dropdownToggle();
select();
toggleTab();
toggleModal(".modal_account", "account", ".btn-close");
toggleModal(".modal_wallet", "wallet", ".btn-close");
toggleModal(".modal_constants", "constants", ".btn-close");
toggleModal(".modal_json", "json", ".btn-close");
toggleModal(".modal_transaction", "transaction", ".btn-close");
