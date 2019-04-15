using UnityEngine;
using System.Collections;
using UnityEngine.SceneManagement;

public class InvertedNormals : MonoBehaviour
{

	GameObject player;
	Scene myScene;
	int sceneId;

	void Start()
	{
		player = GameObject.Find ("Main Camera");
		Input.gyro.enabled = true;
		MeshFilter filter = GetComponent(typeof (MeshFilter)) as MeshFilter;
		if (filter != null)
		{
			Mesh mesh = filter.mesh;

			Vector3[] normals = mesh.normals;
			for (int i=0;i<normals.Length;i++)
				normals[i] = -normals[i];
			mesh.normals = normals;

			for (int m=0;m<mesh.subMeshCount;m++)
			{
				int[] triangles = mesh.GetTriangles(m);
				for (int i=0;i<triangles.Length;i+=3)
				{
					int temp = triangles[i + 0];
					triangles[i + 0] = triangles[i + 1];
					triangles[i + 1] = temp;
				}
				mesh.SetTriangles(triangles, m);
			}
		}

		myScene = SceneManager.GetActiveScene();

		sceneId = myScene.buildIndex;

		switch(sceneId)
		{
			case 1:
					StartCoroutine(Load(36f,sceneId));
					break;
			case 3:
					StartCoroutine(Load(33f,sceneId));
					break;
			case 5:
					StartCoroutine(Load(36f,sceneId));
					break;
			case 7:
					StartCoroutine(Load(30f,sceneId));
					break;
			case 9:
					StartCoroutine(Load(45f,sceneId));
					break;
			case 11:
					StartCoroutine(Load(29f,sceneId));
					break;
			case 13:
					StartCoroutine(Load(42f,sceneId));
					break;
			default :
					break;
		}
	}
	void Update()
	{
		if (Input.GetKeyDown(KeyCode.Escape))
		{
			SceneManager.LoadScene(0);
		}
		player.transform.Rotate (-Input.gyro.rotationRateUnbiased.x, -Input.gyro.rotationRateUnbiased.y*3, 0);
	}

	IEnumerator Load(float delay, int id)
	{
			yield return new WaitForSeconds(delay);
			LoadByIndex(id+1);
	}

	public void LoadByIndex(int sceneIndex)
	{
			SceneManager.LoadScene (sceneIndex);
	}
}
