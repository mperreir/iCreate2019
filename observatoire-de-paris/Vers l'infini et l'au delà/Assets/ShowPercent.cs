using System;
using System.IO;
using System.Text;
using UnityEngine;
using UnityEngine.UI;

public class ShowPercent : MonoBehaviour
{
    //Camera de la scène finale sur Sweeps
    public Camera cameraSweepsFinal;
    //Camera de la scène finale sur Trappist
    public Camera cameraTrappistFinal;
    //Camera de la scène finale sur Wasp
    public Camera cameraWaspFinal;
    //Texte affichant à l'écran les pourcentages
    private Text percent;
    //Booleen permettant d'indiquer ou non si nous avons atteint la fin du jeu
    private bool end = false;
    //String dans laquelle se trouve les données relatives aux choix de planètes utilisateur
    private string path;

    // Start is called before the first frame update
    void Start()
    {
        //Récupération de l'object Text passé en paramètre
        percent = GetComponentInChildren<Text>();
        //Création du path grâce à la variable déjà connue grâce à Unity
        path = Application.persistentDataPath.ToString() + @"/percents.txt";
    }

    // Update is called once per frame
    void Update()
    {
        //Essai de
        try
        {
            //Si le fichier contenant les choix des planètes utilisateur n'existe pas
            if (!File.Exists(path))
            {
                //Création du fichier au path choisi, et relâchement du fichier
                File.CreateText(path).Dispose();
                //Création des premières variables retenant les choix
                string[] firstLines = { "0", "0", "0", "0" };
                //Ajout de ces variables au fichier
                File.WriteAllLines(path, firstLines);
            }

            //Si la caméra finale activée est celle de Sweeps et que nous ne sommes pas déjà à la fin
            if (cameraSweepsFinal.enabled == true && end == false)
            {
                //Récupération des différentes lignes du fichier
                string[] lines = File.ReadAllLines(path);
                //Incrémentation du score de vote de la planète en question
                float newLine0 = float.Parse(lines[0]) + 1;
                //Incrémentation du nombre de vote total
                float newLine3 = float.Parse(lines[3]) + 1;
                //Création d'un pourcentage en fonction des votes
                float resultS = newLine0 / newLine3 * 100;
                //Arrondissement du pourcentage à deux chiffres après la virgule
                double newLineS = Math.Round(resultS, 2);

                //Ecritures des nouveaux scores de vote
                string[] newLines = { newLine0 + "", lines[1], lines[2], newLine3 + "" };
                File.WriteAllLines(path, newLines);

                //Modification du texte affiché en fonction des votes
                percent.text = newLineS + "% des participants ont voté la même chose.";
                //Affichage du texte à l'écran en modifiant son opacité
                percent.color = new Color(1f, 1f, 1f, 1f);

                //Modification du booléen attestant la fin
                end = true;

            }
            //Sinon si la caméra finale activée est celle de Trappist et que nous ne sommes pas déjà à la fin
            else if (cameraTrappistFinal.enabled == true && end == false)
            {
                //Récupération des différentes lignes du fichier
                string[] lines = File.ReadAllLines(path);
                //Incrémentation du score de vote de la planète en question
                float newLine1 = float.Parse(lines[1]) + 1;
                //Incrémentation du nombre de vote total
                float newLine3 = float.Parse(lines[3]) + 1;
                //Création d'un pourcentage en fonction des votes
                float resultT = newLine1 / newLine3 * 100;
                //Arrondissement du pourcentage à deux chiffres après la virgule
                double newLineT = Math.Round(resultT, 2);

                //Ecritures des nouveaux scores de vote
                string[] newLines = { lines[0], newLine1 + "", lines[2], newLine3 + "" };
                File.WriteAllLines(path, newLines);

                //Modification du texte affiché en fonction des votes
                percent.text = newLineT + "% des participants ont voté la même chose.";
                //Affichage du texte à l'écran en modifiant son opacité
                percent.color = new Color(1f, 1f, 1f, 1f);

                //Modification du booléen attestant la fin
                end = true;
            }
            //Sinon si la caméra finale activée est celle de Wasp et que nous ne sommes pas déjà à la fin
            else if (cameraWaspFinal.enabled == true && end == false)
            {
                //Récupération des différentes lignes du fichier
                string[] lines = File.ReadAllLines(path);
                //Incrémentation du score de vote de la planète en question
                float newLine2 = float.Parse(lines[2]) + 1;
                //Incrémentation du nombre de vote total
                float newLine3 = float.Parse(lines[3]) + 1;
                //Création d'un pourcentage en fonction des votes
                float resultW = newLine2 / newLine3 * 100;
                //Arrondissement du pourcentage à deux chiffres après la virgule
                double newLineW = Math.Round(resultW, 2);

                //Ecritures des nouveaux scores de vote
                string[] newLines = { lines[0], lines[1], newLine2 + "", newLine3 + "" };
                File.WriteAllLines(path, newLines);

                //Modification du texte affiché en fonction des votes
                percent.text = newLineW + "% des participants ont voté la même chose.";
                //Affichage du texte à l'écran en modifiant son opacité
                percent.color = new Color(1f, 1f, 1f, 1f);

                //Modification du booléen attestant la fin
                end = true;
            }
        }
        //En cas d'échec, affichage d'une erreur
        catch (Exception e)
        {
            Debug.Log("Exception: " + e.Message);
        }
    }
}
