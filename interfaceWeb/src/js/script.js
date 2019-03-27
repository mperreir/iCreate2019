function enregistrement(id)
{
    if(document.getElementById(id).value=="Démarrer la capture") {
    document.getElementById(id).disabled = true;
        player.record().start();
        setTimeout(function(){
            document.getElementById(id).value = "Etape suivante";
            document.getElementById(id).disabled = false;
        }, 3000);
    } else if (document.getElementById(id).value=="Etape suivante") {
        if (id=="nom") {
            window.location.href = "ville.html";
        } else if (id=="ville") {
            window.location.href = "dispute.html";
        } else if (id=="dispute") {
            window.location.href = "fin.html";
        }
    }
};

function recommencer(id)
{
    window.location.href = id+".html";
    /*if (id=="nom") {
        window.location.href = "nom.html";
    } else if (id=="ville") {
        window.location.href = "ville.html";
    } else if (id=="dispute") {
        window.location.href = "dispute.html";
    }*/
};
