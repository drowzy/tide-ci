defmodule Tide.KeyTest do
  use ExUnit.Case, async: true

  @key """
  -----BEGIN RSA PRIVATE KEY-----
  MIICXAIBAAKBgQCqGKukO1De7zhZj6+H0qtjTkVxwTCpvKe4eCZ0FPqri0cb2JZfXJ/DgYSF6vUp
  wmJG8wVQZKjeGcjDOL5UlsuusFncCzWBQ7RKNUSesmQRMSGkVb1/3j+skZ6UtW+5u09lHNsj6tQ5
  1s1SPrCBkedbNf0Tp0GbMJDyR4e9T04ZZwIDAQABAoGAFijko56+qGyN8M0RVyaRAXz++xTqHBLh
  3tx4VgMtrQ+WEgCjhoTwo23KMBAuJGSYnRmoBZM3lMfTKevIkAidPExvYCdm5dYq3XToLkkLv5L2
  pIIVOFMDG+KESnAFV7l2c+cnzRMW0+b6f8mR1CJzZuxVLL6Q02fvLi55/mbSYxECQQDeAw6fiIQX
  GukBI4eMZZt4nscy2o12KyYner3VpoeE+Np2q+Z3pvAMd/aNzQ/W9WaI+NRfcxUJrmfPwIGm63il
  AkEAxCL5HQb2bQr4ByorcMWm/hEP2MZzROV73yF41hPsRC9m66KrheO9HPTJuo3/9s5p+sqGxOlF
  L0NDt4SkosjgGwJAFklyR1uZ/wPJjj611cdBcztlPdqoxssQGnh85BzCj/u3WqBpE2vjvyyvyI5k
  X6zk7S0ljKtt2jny2+00VsBerQJBAJGC1Mg5Oydo5NwD6BiROrPxGo2bpTbu/fhrT8ebHkTz2epl
  U9VQQSQzY1oZMVX8i1m5WUTLPz2yLJIBQVdXqhMCQBGoiuSoSjafUhV7i1cEGpb88h5NBYZzWXGZ
  37sJ5QsW+sJyoNde3xH8vdXhzU7eT82D6X/scw9RZz+/6rCJ4p0=
  -----END RSA PRIVATE KEY-----
  """

  setup do
    dir = Temp.mkdir!("tide-repo")
    {:ok, pid} = Tide.Key.start_link(dir: dir)

    on_exit(fn ->
      File.rm_rf(dir)
    end)

    {:ok, server: pid, dir: dir}
  end

  test "can add a key to the store", %{server: pid, dir: dir} do
    assert :ok = Tide.Key.add(pid, "myname", @key)
    assert File.exists?(Path.join(dir, "myname"))
  end

  test "can't add a key twice to the same name", %{server: pid} do
    assert :ok = Tide.Key.add(pid, "myname", @key)
    assert {:error, :key_exists} = Tide.Key.add(pid, "myname", @key)
  end

  test "can retrieve a key", %{server: pid} do
    assert :ok = Tide.Key.add(pid, "key.key", @key)
    {:ok, key} = Tide.Key.retrieve(pid, "key.key")

    assert key == @key
  end

  test "can delete a key", %{server: pid, dir: dir} do
    assert :ok = Tide.Key.add(pid, "key.key", @key)
    assert :ok = Tide.Key.remove(pid, "key.key")
    assert not File.exists?(Path.join(dir, "key.key"))
  end

  test "can get keydir", %{server: pid, dir: dir} do
    assert dir == Tide.Key.key_dir(pid)
  end
end
