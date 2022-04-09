# Copyright 2022 XXIV
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
import httpClient
import strformat
import strutils
import tables
import json

type
  DogAPIException* = object of Exception

proc getRequest(endpoint: string): string =
  let client = newhttpClient()
  let response = client.request("https://dog.ceo/api/" & endpoint, httpMethod = HttpGet)
  return response.body


## Dog API client

proc randomImage*(): string =
  ## DISPLAY SINGLE RANDOM IMAGE FROM ALL DOGS COLLECTION
  ##
  ## return a random dog image
  ##
  ## Raises DogAPIException
  try:
      let response = getRequest("breeds/image/random")
      let json = parseJson(response)
      if json["status"].getStr() != "success":
        raise DogAPIException.newException(json["message"].getStr())
      return json["message"].getStr()
  except:
    raise DogAPIException.newException(getCurrentExceptionMsg())


proc multipleRandomImages*(imagesNumber: int): seq[string] =
  ## DISPLAY MULTIPLE RANDOM IMAGES FROM ALL DOGS COLLECTION
  ##
  ## * `imagesNumber` number of images
  ##
  ## *NOTE* ~ Max number returned is 50
  ##
  ## Return multiple random dog image
  ## Raises DogAPIException
  try:
      let response = getRequest(fmt"breeds/image/random/{imagesNumber}")
      let json = parseJson(response)
      if json["status"].getStr() != "success":
        raise DogAPIException.newException(json["message"].getStr())
      var array: seq[string] = @[]
      for i in json["message"]:
        array.add(i.getStr())
      return array
  except:
    raise DogAPIException.newException(getCurrentExceptionMsg())


proc randomImageByBreed*(breed: string): string =
  ## RANDOM IMAGE FROM A BREED COLLECTION
  ##
  ## * `breed` breed name
  ##
  ## Returns a random dog image from a breed, e.g. hound
  ## Raises DogAPIException
  try:
      let response = getRequest(fmt"breed/{breed.strip}/images/random")
      let json = parseJson(response)
      if json["status"].getStr() != "success":
        raise DogAPIException.newException(json["message"].getStr())
      return json["message"].getStr()
  except:
    raise DogAPIException.newException(getCurrentExceptionMsg())


proc multipleRandomImagesByBreed*(breed: string, imagesNumber: int): seq[string] =
  ## MULTIPLE IMAGES FROM A BREED COLLECTION
  ##
  ## * `breed` breed name
  ## * `imagesNumber` number of images
  ##
  ## Return multiple random dog image from a breed, e.g. hound
  ## Raises DogAPIException
  try:
      let response = getRequest(fmt"breed/{breed.strip}/images/random/{imagesNumber}")
      let json = parseJson(response)
      if json["status"].getStr() != "success":
        raise DogAPIException.newException(json["message"].getStr())
      var array: seq[string] = @[]
      for i in json["message"]:
        array.add(i.getStr())
      return array
  except:
    raise DogAPIException.newException(getCurrentExceptionMsg())


proc imagesByBreed*(breed: string): seq[string] =
  ## ALL IMAGES FROM A BREED COLLECTION
  ##
  ## * `breed` breed name
  ##
  ## Returns sequence of all the images from a breed, e.g. hound
  ## Raises DogAPIException
  try:
      let response = getRequest(fmt"breed/{breed.strip}/images")
      let json = parseJson(response)
      if json["status"].getStr() != "success":
        raise DogAPIException.newException(json["message"].getStr())
      var array: seq[string] = @[]
      for i in json["message"]:
        array.add(i.getStr())
      return array
  except:
    raise DogAPIException.newException(getCurrentExceptionMsg())


proc randomImageBySubBreed*(breed: string, subBreed: string): string =
  ## SINGLE RANDOM IMAGE FROM A SUB BREED COLLECTION
  ##
  ## * `breed` breed name
  ## * `subBreed` sub_breed name
  ##
  ## Returns a random dog image from a sub-breed, e.g. Afghan Ho
  ## Raises DogAPIException
  try:
      let response = getRequest(fmt"breed/{breed.strip}/{subBreed.strip}/images/random")
      let json = parseJson(response)
      if json["status"].getStr() != "success":
        raise DogAPIException.newException(json["message"].getStr())
      return json["message"].getStr()
  except:
    raise DogAPIException.newException(getCurrentExceptionMsg())


proc multipleRandomImagesBySubBreed*(breed: string, subBreed: string, imagesNumber: int): seq[string] =
  ## MULTIPLE IMAGES FROM A SUB-BREED COLLECTION
  ##
  ## * `breed` breed name
  ## * `subBreed` sub_breed name
  ## * `imagesNumber` number of images
  ##
  ## Return multiple random dog images from a sub-breed, e.g. Afghan Hound
  ## Raises DogAPIException
  try:
      let response = getRequest(fmt"breed/{breed.strip}/{subBreed.strip}/images/random/{imagesNumber}")
      let json = parseJson(response)
      if json["status"].getStr() != "success":
        raise DogAPIException.newException(json["message"].getStr())
      var array: seq[string] = @[]
      for i in json["message"]:
        array.add(i.getStr())
      return array
  except:
    raise DogAPIException.newException(getCurrentExceptionMsg())


proc imagesBySubBreed*(breed: string, subBreed: string): seq[string] =
  ## LIST ALL SUB-BREED IMAGES
  ##
  ## * `breed` breed name
  ## * `subBreed` sub_breed name
  ##
  ## Returns sequence of all the images from the sub-breed
  ## Raises DogAPIException
  try:
      let response = getRequest(fmt"breed/{breed.strip}/{subBreed.strip}/images")
      let json = parseJson(response)
      if json["status"].getStr() != "success":
        raise DogAPIException.newException(json["message"].getStr())
      var array: seq[string] = @[]
      for i in json["message"]:
        array.add(i.getStr())
      return array
  except:
    raise DogAPIException.newException(getCurrentExceptionMsg())


proc breedsList*(): Table[string, seq[string]] =
  ## LIST ALL BREEDS
  ##
  ## Returns table of all the breeds as keys and sub-breeds as values if it has
  ## Raises DogAPIException
  try:
      let response = getRequest("breeds/list/all")
      let json = parseJson(response)
      if json["status"].getStr() != "success":
        raise DogAPIException.newException(json["message"].getStr())
      var map = initTable[string, seq[string]]()
      for k,v in json["message"]:
        var valArray: seq[string] = @[]
        for value in v:
          valArray.add(value.getStr())
        map[k] = valArray
      return map
  except:
    raise DogAPIException.newException(getCurrentExceptionMsg())


proc subBreedsList*(breed: string): seq[string] =
  ## LIST ALL SUB-BREEDS
  ##
  ## * `breed` breed name
  ##
  ## Returns sequence of all the sub-breeds from a breed if it has sub-breeds
  ## Raises DogAPIException
  try:
      let response = getRequest(fmt"breed/{breed.strip}/list")
      let json = parseJson(response)
      if json["status"].getStr() != "success":
        raise DogAPIException.newException(json["message"].getStr())
      var array: seq[string] = @[]
      for i in json["message"]:
        array.add(i.getStr())
      if array.len == 0:
        raise DogAPIException.newException("the breed does not have sub-breeds")
      return array
  except:
    raise DogAPIException.newException(getCurrentExceptionMsg())