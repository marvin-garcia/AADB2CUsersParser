using System;
using System.Configuration;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Newtonsoft.Json;
using System.IO;
using Newtonsoft.Json.Linq;

namespace B2CUserParser
{
    class Program
    {
        private static string _sourceFile = ConfigurationManager.AppSettings["SourceFile"];
        private static string _destinationFolder = ConfigurationManager.AppSettings["DestinationFolder"];

        static void Main(string[] args)
        {
            if (!Directory.Exists(_destinationFolder))
                Directory.CreateDirectory(_destinationFolder);

            string fileContent = File.ReadAllText(_sourceFile);
            JArray usersArray = JsonConvert.DeserializeObject<JArray>(fileContent);

            Console.WriteLine($"Total users: {usersArray.Count()}");

            int count = 1;
            foreach (JObject user in usersArray)
            {
                string userString = JsonConvert.SerializeObject(user);
                var signInName = user["signInNames"][0]["value"];

                Console.WriteLine($"User {count}/{usersArray.Count()}: {signInName}");
                File.WriteAllText($"{_destinationFolder}\\{signInName}.json", userString);
                count++;
            }

            Console.WriteLine("Task completed. Press Enter to exit");
            Console.Read();
        }
    }
}
