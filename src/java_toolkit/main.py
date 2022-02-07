#!/usr/local/bin/python3
import subprocess
import typer
from .common.utils.process import *
from .common.utils.remote_ns_cmd import run_cmd_in_proc_namespace
from .common.utils.tmp_mount import TmpRemotePodMounter
from .configs import *

app = typer.Typer()

def get_matching_local_pid(pid: int, verbose: bool):
    process_cmd = ' '.join(get_pid_info(pid).cmdline)
    ns_processes = get_ns_processes(pid, verbose)
    process_list = []
    for ns_process in ns_processes.processes:
        ns_process_cmd = ' '.join(ns_process.cmdline)
        if process_cmd == ns_process_cmd:
            process_list.append(ns_process)
    if len(process_list) != 1:
        raise Exception(f"{len(process_list)} match the pid {pid} args '{process_cmd}'")
    return process_list[0].pid

def run_jdk_cmd(pid: int, cmd_missing_jdk_path:str, add_local_pid: bool, verbose: bool):
    with TmpRemotePodMounter(pid, JDK_PATH, LOCAL_MOUNT_PATH, verbose) as jdk_mounter:
        cmd = cmd_missing_jdk_path
        if add_local_pid:
            local_pid = get_matching_local_pid(pid, verbose)
            cmd = cmd.format(jdk_path=jdk_mounter.get_mounted_jdk_dir(),pid=local_pid)
        else:
            cmd = cmd.format(jdk_path=jdk_mounter.get_mounted_jdk_dir())
        output =  run_cmd_in_proc_namespace(pid, cmd, verbose)
        typer.echo(output)


@app.command()
def pod_ps(pod_uid: str):
    typer.echo(get_pod_processes(pod_uid).json())


@app.command()
def pod_ns_ps(pid: int, verbose: bool = False):
    typer.echo(get_ns_processes(pid, verbose).json())


@app.command()
def jmap(pid: int, verbose: bool = False):
    run_jdk_cmd(pid, JMAP_CMD, add_local_pid=True, verbose=verbose)



@app.command()
def jstack(pid: int, verbose: bool = False):
    run_jdk_cmd(pid, JSTACK_CMD, add_local_pid=True, verbose=verbose)


if __name__ == "__main__":
    app()
