function enregistrement(id)
{
    console.log(id);
    if(document.getElementById(id).value=="Commencer") {
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
