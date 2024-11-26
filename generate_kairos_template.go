package main

import (
	"fmt"
	"os"
	"text/template"
)

type TemplateData struct {
	UserName  string
	Password  string
	PubKey    string
	IPAddress string
}

func main() {
	data, err := initTemplateData()
	if err != nil {
		panic(err)
	}

	tmplFile := "kairos_config.yaml"
	tmpl, err := template.New(tmplFile).ParseFiles(tmplFile)
	if err != nil {
		panic(err)
	}

	outFile, err := os.Create("90_custom.yaml")
	if err != nil {
		panic(err)
	}

	if err := tmpl.Execute(outFile, data); err != nil {
		panic(err)
	}
}

func initTemplateData() (TemplateData, error) {
	var envErrs []string
	var data TemplateData

	user, exists := os.LookupEnv("USER")
	if !exists {
		envErrs = append(envErrs, "USER")
	} else {
		data.UserName = user
	}

	password, exists := os.LookupEnv("PASSWORD")
	if !exists {
		envErrs = append(envErrs, "PASSWORD")
	} else {
		data.Password = password
	}

	// pubKey, exists := os.LookupEnv("PUB_KEY")
	// if !exists {
	// 	envErrs = append(envErrs, "PUB_KEY")
	// } else {
	// 	data.PubKey = pubKey
	// }

	ipAddr, exists := os.LookupEnv("IP_ADDR")
	if !exists {
		envErrs = append(envErrs, "IP_ADDR")
	} else {
		data.IPAddress = ipAddr
	}

	if len(envErrs) > 0 {
		var errMsg string
		for _, err := range envErrs {
			errMsg += "ERROR: Missing environment variable '" + err + "'\n"
		}

		return TemplateData{}, fmt.Errorf(errMsg)
	}

	return data, nil
}
